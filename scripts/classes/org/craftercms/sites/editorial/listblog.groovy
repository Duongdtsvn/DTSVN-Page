package org.craftercms.sites.editorial

import org.opensearch.client.opensearch._types.SortOrder
import org.opensearch.client.opensearch._types.query_dsl.BoolQuery
import org.opensearch.client.opensearch._types.query_dsl.Query
import org.opensearch.client.opensearch._types.query_dsl.TextQueryType
import org.opensearch.client.opensearch._types.analysis.Analyzer
import org.opensearch.client.opensearch.core.SearchRequest
import org.opensearch.client.opensearch.core.search.Highlight
import org.apache.commons.lang3.StringUtils
import org.craftercms.engine.service.UrlTransformationService
import org.craftercms.search.opensearch.client.OpenSearchClientWrapper

// Lớp BlogSearchHelper dùng để tìm kiếm bài tuyển dụng theo các tiêu chí chỉ định.
class BlogSearchHelper {
    
    // Hằng số CONTENT_TYPE định nghĩa loại nội dung của trang tuyển dụng muốn lấy.
    // Đây là giá trị của trường "content-type" trong chỉ mục, được dùng để lọc các trang cần hiển thị.
    static final String CONTENT_TYPE = "/page/blog" 

    // Cấu hình cho vị trí bắt đầu và số lượng bản ghi trả về mặc định
    static final int DEFAULT_START = 0
    static final int DEFAULT_ROWS = 10

    // Analyzer dùng để xử lý các giá trị khi truyền vào bộ lọc trong query, sử dụng kiểu Whitespace (tách theo khoảng trắng)
    static final String MULTIPLE_VALUES_SEARCH_ANALYZER = Analyzer.Kind.Whitespace.jsonValue()

    // Khai báo các đối tượng cần thiết để gọi truy vấn lên OpenSearch và chuyển đổi URL.
    OpenSearchClientWrapper searchClient
    UrlTransformationService urlTransformationService

    // Constructor của lớp, khởi tạo searchClient và urlTransformationService từ bên ngoài
    BlogSearchHelper(OpenSearchClientWrapper searchClient, UrlTransformationService urlTransformationService) {
        this.searchClient = searchClient
        this.urlTransformationService = urlTransformationService
    }

    /**
     * Phương thức getAllBlogs lấy các bài tuyển dụng từ hệ thống.
     * Nó sẽ truy vấn dữ liệu từ các trang mà content-type có giá trị được định nghĩa ở CONTENT_TYPE.
     *
     * Nếu categoryKey có giá trị, bộ lọc sẽ được áp dụng theo taxonomy dựa trên file /site/taxonomy/tuyen-dung.xml.
     *
     * @param categoryKey (Tùy chọn) Giá trị taxonomy để lọc bài tuyển dụng. Nếu null hoặc rỗng thì không dùng bộ lọc taxonomy.
     * @param start Vị trí bắt đầu (offset) của các kết quả truy vấn, mặc định là 0.
     * @param rows Số lượng bản ghi trả về, mặc định là 10.
     * @return Danh sách map chứa dữ liệu của bài tuyển dụng, gồm thông tin chính cần hiển thị.
     */
    def getAllBlogs(def categoryKey, int start = DEFAULT_START, int rows = DEFAULT_ROWS) {
        // Xây dựng đối tượng searchRequest với truy vấn được đóng gói bởi SearchRequest.of.
        // Đây là phần cấu hình truy vấn cho OpenSearch.
        def searchRequest = SearchRequest.of(r -> r
            // Xác định phần query sử dụng kiểu Bool (nhiều tiêu chí) cho phép kết hợp nhiều filter lại với nhau.
            .query(q -> q
                .bool(b -> {
                    // Bộ lọc đầu tiên: lọc theo "content-type" phải có giá trị bằng CONTENT_TYPE.
                    // Điều này đảm bảo chỉ trả về các trang có nội dung tuyển dụng.
                    b.filter(f -> f
                        .match(m -> m
                            .field("content-type")
                            .query(v -> v.stringValue(CONTENT_TYPE))
                        )
                    )
                    // Nếu có categoryKey được truyền vào, thêm bộ lọc cho taxonomy dựa trên trường "categories_o.item.key".
                    if (categoryKey) {
                        b.filter(getFieldQueryWithMultipleValuesRe("categories_o.item.key", categoryKey))
                    }
                    // Trả về đối tượng boolean query đã xây dựng.
                    return b
                })
            )
            // Cấu hình phân trang: .from(start) xác định vị trí bắt đầu, .size(rows) số lượng bản ghi trả về.
            .from(start)
            .size(rows)
            // Sắp xếp kết quả theo trường "date_dt" theo thứ tự giảm dần.
            .sort(s -> s
                .field(f -> f
                    .field("date_dt")
                    .order(SortOrder.Desc)
                )
            )
        )

        // Gọi hàm search() từ searchClient để thực thi truy vấn. Kết quả được chuyển thành dạng Map.
        def result = searchClient.search(searchRequest, Map)

        // Nếu có kết quả, tiến hành xử lý chúng qua processResults, ngược lại trả về danh sách rỗng.
        if (result) {
            return processResults(result)
        } else {
            return []
        }
    }

    // Phương thức processResults nhận kết quả truy vấn và chuyển đổi chúng thành danh sách các map chứa dữ liệu hiển thị.
    private def processResults(result) {
        def items = []
        // Lấy danh sách các tài liệu (document) từ hits của kết quả truy vấn.
        def documents = result.hits().hits()*.source()
    
        // Nếu có dữ liệu trong documents, lặp qua từng tài liệu để thu thập các trường cần thiết.
        if (documents) {
            documents.each { doc ->
                def item = [:]

                item.image_s         = doc.content_image_s
                item.title1_s          = doc.title1_s
                item.date_s             = doc.content_date_s
                item.url                = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)
                
                // Thêm item vào danh sách các kết quả trả về.
                items << item
            }
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
}
