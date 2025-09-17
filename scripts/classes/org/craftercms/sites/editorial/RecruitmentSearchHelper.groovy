package org.craftercms.sites.editorial

import org.opensearch.client.opensearch._types.SortOrder
import org.opensearch.client.opensearch._types.query_dsl.BoolQuery
import org.opensearch.client.opensearch._types.query_dsl.Query
import org.opensearch.client.opensearch._types.query_dsl.TextQueryType
import org.opensearch.client.opensearch._types.analysis.Analyzer
import org.opensearch.client.opensearch.core.SearchRequest
import org.opensearch.client.opensearch.core.search.Highlight
import org.opensearch.client.opensearch._types.SortOptions
import org.opensearch.client.opensearch._types.FieldSort
import org.apache.commons.lang3.StringUtils
import org.craftercms.engine.service.UrlTransformationService
import org.craftercms.search.opensearch.client.OpenSearchClientWrapper

// Class này chịu trách nhiệm xử lý tìm kiếm các bài tuyển dụng
class RecruitmentSearchHelper {
    
    // Định nghĩa loại content type để lọc
    // Chỉ lấy các trang có content-type là "/page/page-recruitment-detail"
    static final String CONTENT_TYPE = "/page/page-recruitment-detail" 

    // Các giá trị mặc định cho phân trang
    static final int DEFAULT_START = 0  // Bắt đầu từ item đầu tiên
    static final int DEFAULT_ROWS = 10  // Mặc định 10 items/trang

    // Các giá trị sắp xếp được hỗ trợ
    static final String SORT_NEWEST = "newest"      // Mới nhất đến cũ nhất
    static final String SORT_OLDEST = "oldest"      // Cũ nhất đến mới nhất
    static final String SORT_A_TO_Z = "a_to_z"     // A đến Z theo tên
    static final String SORT_Z_TO_A = "z_to_a"     // Z đến A theo tên
    static final String DEFAULT_SORT = SORT_NEWEST  // Mặc định sắp xếp mới nhất

    // Analyzer dùng để xử lý các giá trị khi truyền vào bộ lọc trong query, sử dụng kiểu Whitespace (tách theo khoảng trắng)
    static final String MULTIPLE_VALUES_SEARCH_ANALYZER = Analyzer.Kind.Whitespace.jsonValue()

    // Khai báo các đối tượng cần thiết để gọi truy vấn lên OpenSearch và chuyển đổi URL.
    OpenSearchClientWrapper searchClient
    UrlTransformationService urlTransformationService

    // Constructor của lớp, khởi tạo searchClient và urlTransformationService từ bên ngoài
    RecruitmentSearchHelper(OpenSearchClientWrapper searchClient, UrlTransformationService urlTransformationService) {
        this.searchClient = searchClient
        this.urlTransformationService = urlTransformationService
    }

    /**
     * Phương thức getAllRecruitments lấy các bài tuyển dụng từ hệ thống.
     * Nó sẽ truy vấn dữ liệu từ các trang mà content-type có giá trị được định nghĩa ở CONTENT_TYPE.
     *
     * Nếu categoryKey có giá trị, bộ lọc sẽ được áp dụng theo taxonomy dựa trên file /site/taxonomy/tuyen-dung.xml.
     *
     * @param searchParams Map chứa các tham số tìm kiếm (title, location, quantity, deadline)
     * @param start Vị trí bắt đầu (offset) của các kết quả truy vấn, mặc định là 0.
     * @param rows Số lượng bản ghi trả về, mặc định là 10.
     * @param sort Tham số sắp xếp (newest, oldest, a_to_z, z_to_a), mặc định là newest.
     * @return Danh sách map chứa dữ liệu của bài tuyển dụng, gồm thông tin chính cần hiển thị.
     */
    def getAllRecruitments(Map searchParams = [:], int start = DEFAULT_START, int rows = DEFAULT_ROWS, String sort = DEFAULT_SORT) {
        try {
            def query = new BoolQuery.Builder()

            // Filter by content-type
            query.filter(q -> q
                .match(m -> m
                    .field("content-type")
                    .query(v -> v.stringValue(CONTENT_TYPE))
                )
            )

            // Xử lý tìm kiếm theo các tham số
            if (searchParams.title || searchParams.location || searchParams.quantity || searchParams.deadline) {
                query.minimumShouldMatch("1")
                
                // Tìm kiếm theo tiêu đề
                if (searchParams.title) {
                    query.should(q -> q
                        .multiMatch(m -> m
                            .query(searchParams.title)
                            .fields(SEARCH_FIELDS)
                            .type(TextQueryType.PhrasePrefix)
                            .boost(1.5f)
                        )
                    )
                    query.should(q -> q
                        .multiMatch(m -> m
                            .query(searchParams.title)
                            .fields(SEARCH_FIELDS)
                        )
                    )
                }

                // Tìm kiếm theo địa điểm
                if (searchParams.location) {
                    query.should(q -> q
                        .multiMatch(m -> m
                            .query(searchParams.location)
                            .fields(SEARCH_FIELDS)
                            .type(TextQueryType.PhrasePrefix)
                            .boost(1.2f)
                        )
                    )
                    query.should(q -> q
                        .multiMatch(m -> m
                            .query(searchParams.location)
                            .fields(SEARCH_FIELDS)
                        )
                    )
                }

                // Tìm kiếm theo số lượng
                if (searchParams.quantity) {
                    query.should(q -> q
                        .multiMatch(m -> m
                            .query(searchParams.quantity.toString())
                            .fields(SEARCH_FIELDS)
                        )
                    )
                }

                // Tìm kiếm theo thời hạn
                if (searchParams.deadline) {
                    query.should(q -> q
                        .multiMatch(m -> m
                            .query(searchParams.deadline)
                            .fields(SEARCH_FIELDS)
                        )
                    )
                }
            }

            def searchRequest = SearchRequest.of(r -> r
                .query(query.build()._toQuery())
                .from(start)
                .size(rows)
                .sort(getSortCriteria(sort))
            )

            def result = searchClient.search(searchRequest, Map)

            if (result) {
                return processResults(result)
            } else {
                return []
            }
        } catch (Exception e) {
            // Log error and return empty list
            return []
        }
    }

    /**
     * Phương thức này dùng để đếm tổng số bài tuyển dụng trong hệ thống.
     * Thường được sử dụng để:
     * - Tính toán số trang cho phân trang (pagination)
     * - Hiển thị tổng số tin tuyển dụng
     * 
     * @param searchParams Map chứa các tham số tìm kiếm
     * @return Số lượng bài tuyển dụng thỏa mãn điều kiện
     */
    def getTotalRecruitments(Map searchParams = [:]) {
        try {
            def queryBuilder = new BoolQuery.Builder()

            // Filter by content-type
            queryBuilder.filter(q -> q
                .match(m -> m
                    .field("content-type")
                    .query(v -> v.stringValue(CONTENT_TYPE))
                )
            )

            def searchFieldsBool = new BoolQuery.Builder()
            def hasSearchParams = false

            if (searchParams.title) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("title_main_s")
                        .value(".*${searchParams.title}.*")
                        .caseInsensitive(true)
                    )
                )
            }
            if (searchParams.location) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("content_dia_diem_lam_viec_s")
                        .value(".*${searchParams.location}.*")
                        .caseInsensitive(true)
                    )
                )
            }
            if (searchParams.quantity) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("content_so_luong_lam_viec_s")
                        .value(".*${searchParams.quantity}.*")
                        .caseInsensitive(true)
                    )
                )
            }
            if (searchParams.deadline) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("content_han_nop_ho_so_s")
                        .value(".*${searchParams.deadline}.*")
                        .caseInsensitive(true)
                    )
                )
            }

            if (hasSearchParams) {
                queryBuilder.must(b -> b.bool(searchFieldsBool.build()))
            }

            def searchRequest = SearchRequest.of(r -> r
                .query(queryBuilder.build()._toQuery())
                .size(0)
            )

            def result = searchClient.search(searchRequest, Map)
            return result.hits().total().value()
        } catch (Exception e) {
            // Return 0 if there's an error
            return 0
        }
    }

    // Phương thức processResults nhận kết quả truy vấn và chuyển đổi chúng thành danh sách các map chứa dữ liệu hiển thị.
    private def processResults(result) {
        def items = []
        try {
            // Lấy danh sách các tài liệu (document) từ hits của kết quả truy vấn.
            def documents = result.hits().hits()*.source()
        
            // Nếu có dữ liệu trong documents, lặp qua từng tài liệu để thu thập các trường cần thiết.
            if (documents) {
                documents.each { doc ->
                    try {
                        def item = [:]

                        item.title_main         = doc.title_main_s ?: ""
                        item.phong_ban          = doc.content_phong_ban_s ?: ""
                        item.vi_tri             = doc.content_vi_tri_s ?: ""
                        item.dia_diem_lam_viec  = doc.content_dia_diem_lam_viec_s ?: ""
                        item.so_luong_lam_viec  = doc.content_so_luong_lam_viec_s ?: ""
                        item.han_nop_ho_so      = doc.content_han_nop_ho_so_s ?: ""
                        item.url                = doc.localId ? urlTransformationService.transform("storeUrlToRenderUrl", doc.localId) : ""
                        
                        // Thêm item vào danh sách các kết quả trả về.
                        items << item
                    } catch (Exception e) {
                        // Skip this document if there's an error processing it
                    }
                }
            }
        } catch (Exception e) {
            // Return empty list if there's an error
        }
    
        return items
    }

    // Phương thức getFieldQueryWithMultipleValuesRe xử lý giá trị của trường khi giá trị truyền vào có thể là chuỗi đơn hay danh sách (Iterable).
    // Sau đó sẽ xây dựng truy vấn match cho field đó với giá trị đã được ép kiểu và nối chuỗi nếu cần.
    // Sử dụng analyzer định nghĩa để tách từ theo khoảng trắng cho phù hợp.
    private Query getFieldQueryWithMultipleValuesRe(field, values) {
        // Nếu values là mảng thì chuyển đổi sang List để dễ xử lý.
        if (values.class.isArray()) {
            values = values as List
        }

        // Nếu values là Iterable (ví dụ: danh sách nhiều giá trị) thì ghép nối các phần tử thành một chuỗi cách nhau bởi dấu cách.
        if (values instanceof Iterable) {
            values = StringUtils.join((Iterable) values, " ") as String
        } else {
            // Nếu không thì ép kiểu trực tiếp thành chuỗi.
            values = values as String
        }

        // Xây dựng query match với field được chỉ định, truyền giá trị đã xử lý,
        // sử dụng analyzer MULTIPLE_VALUES_SEARCH_ANALYZER để đảm bảo giá trị được phân tích đúng.
        return Query.of(q -> q
            .match(m -> m
                .field(field)
                .query(v -> v.stringValue(values))
                .analyzer(MULTIPLE_VALUES_SEARCH_ANALYZER)
            )
        )
    }

    /**
     * Phương thức này tạo ra các tiêu chí sắp xếp dựa trên tham số sort được truyền vào.
     * 
     * @param sort Tham số sắp xếp (newest, oldest, a_to_z, z_to_a)
     * @return Danh sách các tiêu chí sắp xếp cho OpenSearch
     */
    private def getSortCriteria(String sort) {
        switch (sort) {
            case SORT_OLDEST:
                return [SortOptions.of(s -> s
                    .field(f -> f
                        .field("date_dt")
                        .order(SortOrder.Asc)
                    )
                )]
            case SORT_A_TO_Z:
                return [SortOptions.of(s -> s
                    .field(f -> f
                        .field("title_main_s.keyword")
                        .order(SortOrder.Asc)
                    )
                )]
            case SORT_Z_TO_A:
                return [SortOptions.of(s -> s
                    .field(f -> f
                        .field("title_main_s.keyword")
                        .order(SortOrder.Desc)
                    )
                )]
            case SORT_NEWEST:
            default:
                return [SortOptions.of(s -> s
                    .field(f -> f
                        .field("date_dt")
                        .order(SortOrder.Desc)
                    )
                )]
        }
    }

    /**
     * Phương thức tìm kiếm nâng cao với hỗ trợ fuzzy matching và case-insensitive
     * @param searchParams Map chứa các tham số tìm kiếm
     * @param start Vị trí bắt đầu
     * @param rows Số lượng bản ghi
     * @param sort Tham số sắp xếp
     * @return Danh sách kết quả tìm kiếm
     */
    def searchRecruitmentsAdvanced(Map searchParams = [:], int start = DEFAULT_START, int rows = DEFAULT_ROWS, String sort = DEFAULT_SORT) {
        try {
            def queryBuilder = new BoolQuery.Builder()

            // Filter by content-type
            queryBuilder.filter(q -> q
                .match(m -> m
                    .field("content-type")
                    .query(v -> v.stringValue(CONTENT_TYPE))
                )
            )

            def searchFieldsBool = new BoolQuery.Builder()
            def hasSearchParams = false

            if (searchParams.title) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("title_main_s")
                        .value(".*${searchParams.title}.*")
                        .caseInsensitive(true)
                    )
                )
            }
            if (searchParams.location) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("content_dia_diem_lam_viec_s")
                        .value(".*${searchParams.location}.*")
                        .caseInsensitive(true)
                    )
                )
            }
            if (searchParams.quantity) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("content_so_luong_lam_viec_s")
                        .value(".*${searchParams.quantity}.*")
                        .caseInsensitive(true)
                    )
                )
            }
            if (searchParams.deadline) {
                hasSearchParams = true
                searchFieldsBool.should(s -> s
                    .regexp(r -> r
                        .field("content_han_nop_ho_so_s")
                        .value(".*${searchParams.deadline}.*")
                        .caseInsensitive(true)
                    )
                )
            }

            if (hasSearchParams) {
                queryBuilder.must(b -> b.bool(searchFieldsBool.build()))
            }
            
            def searchRequest = SearchRequest.of(r -> r
                .query(queryBuilder.build()._toQuery())
                .from(start)
                .size(rows)
                .sort(getSortCriteria(sort))
            )

            def result = searchClient.search(searchRequest, Map)

            if (result) {
                return processResults(result)
            } else {
                return []
            }
        } catch (Exception e) {
            // For now, just return empty on error
            return []
        }
    }
}
