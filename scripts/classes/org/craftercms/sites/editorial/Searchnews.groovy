/*
 * Copyright (C) 2007-2022 Crafter Software Corporation. All Rights Reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as published by
 * the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.craftercms.sites.editorial

// Import các thư viện cần thiết cho OpenSearch và xử lý dữ liệu
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
import java.time.ZonedDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter

/**
 * Class Searchnews - Quản lý tìm kiếm và lấy dữ liệu tin tức từ OpenSearch
 * Chức năng chính: tìm kiếm tin tức, lấy tất cả tin tức, lọc theo danh mục
 */
class Searchnews {

  // ===== CÁC HẰNG SỐ CẤU HÌNH =====
  // Định nghĩa loại nội dung tin tức để lọc dữ liệu
  static final String ITEM_NEW_CONTENT_TYPE = "/page/item-new"
  
  // Đường dẫn thư mục chứa tin tức/blog
  static final String LIST_BLOG_PATH = "/site/website/list-blog"
  
  // Các trường dữ liệu để tìm kiếm với độ ưu tiên khác nhau
  // ^2.0 = độ ưu tiên cao nhất, ^1.5 = ưu tiên trung bình, ^1.0 = ưu tiên thấp
  static final List<String> ITEM_NEW_SEARCH_FIELDS = [
    'title_vi_s^2.0',      // Tiêu đề tiếng Việt (ưu tiên cao nhất)
    'content_vi_html^1.0', // Nội dung tiếng Việt
    'title_en_s^1.5',      // Tiêu đề tiếng Anh (ưu tiên trung bình)
    'content_en_html^1.0'  // Nội dung tiếng Anh
  ]
  
  // Các trường sẽ được highlight (làm nổi bật) khi tìm kiếm
  static final String[] HIGHLIGHT_FIELDS = ["title_vi_s", "content_vi_html", "title_en_s", "content_en_html"]
  
  // Cấu hình mặc định cho phân trang
  static final int DEFAULT_START = 0    // Vị trí bắt đầu mặc định
  static final int DEFAULT_ROWS = 50    // Số lượng kết quả mặc định
  
  // Bộ phân tích từ khóa cho tìm kiếm nhiều giá trị
  static final String MULTIPLE_VALUES_SEARCH_ANALYZER = Analyzer.Kind.Whitespace.jsonValue()

  // ===== CÁC SERVICE CẦN THIẾT =====
  // Client để kết nối và tương tác với OpenSearch
  OpenSearchClientWrapper searchClient
  
  // Service để chuyển đổi URL từ store URL sang render URL
  UrlTransformationService urlTransformationService

  /**
   * Constructor - Khởi tạo class với các service cần thiết
   * @param searchClient - Client kết nối OpenSearch
   * @param urlTransformationService - Service chuyển đổi URL
   */
  Searchnews(OpenSearchClientWrapper searchClient, UrlTransformationService urlTransformationService) {
    this.searchClient = searchClient
    this.urlTransformationService = urlTransformationService
  }

  /**
   * Tìm kiếm tin tức với từ khóa và danh mục, cho phép chỉ định trường tìm kiếm cụ thể
   * @param userTerm - Từ khóa tìm kiếm của người dùng
   * @param categories - Danh mục cần lọc
   * @param start - Vị trí bắt đầu (mặc định 0)
   * @param rows - Số lượng kết quả (mặc định 50)
   * @param searchField - (Tùy chọn) Chỉ tìm kiếm trên trường này (vd: 'title_vi_s' hoặc 'title_en_s')
   * @return Danh sách tin tức phù hợp
   */
  def searchNews(userTerm, categories, start = DEFAULT_START, rows = DEFAULT_ROWS, searchField = null) {
    def query = new BoolQuery.Builder()

    // ===== BƯỚC 1: LỌC THEO LOẠI NỘI DUNG =====
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v
          .stringValue(ITEM_NEW_CONTENT_TYPE)
        )
      )
    )

    // ===== BƯỚC 2: LỌC THEO ĐƯỜNG DẪN =====
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + LIST_BLOG_PATH + "*")
      )
    )

    // ===== BƯỚC 3: LỌC THEO DANH MỤC (NẾU CÓ) =====
    if (categories) {
      query.filter(getFieldQueryWithMultipleValues("categorys_o.item.key", categories))
    }

    // ===== BƯỚC 4: XỬ LÝ TỪ KHÓA TÌM KIẾM =====
    if (userTerm) {
      // Nếu truyền vào searchField thì chỉ tìm trên trường đó
      def fields = searchField ? [searchField] : ITEM_NEW_SEARCH_FIELDS
      // Tìm kiếm phrase prefix với boost cao nhất
      query.should(q -> q
        .multiMatch(m -> m
          .query(userTerm)
          .fields(fields)
          .type(TextQueryType.PhrasePrefix)
          .boost(2.0f)
        )
      )
      // Tìm kiếm match với operator OR (tương đối hơn)
      query.should(q -> q
        .multiMatch(m -> m
          .query(userTerm)
          .fields(fields)
          .operator(org.opensearch.client.opensearch._types.query_dsl.Operator.Or)
          .boost(1.5f)
        )
      )
      // Tìm kiếm fuzzy để bắt lỗi chính tả
      query.should(q -> q
        .multiMatch(m -> m
          .query(userTerm)
          .fields(fields)
          .fuzziness("AUTO")
          .boost(1.0f)
        )
      )
      // Tìm kiếm wildcard để bắt các từ có chứa từ khóa
      fields.each { field ->
        query.should(q -> q
          .wildcard(w -> w
            .field(field)
            .value("*" + userTerm + "*")
            .caseInsensitive(true)
            .boost(0.8f)
          )
        )
      }
    }

    // Cấu hình highlight để làm nổi bật từ khóa tìm kiếm
    def highlighter = new Highlight.Builder();
    def highlightFields = searchField ? [searchField] : HIGHLIGHT_FIELDS
    highlightFields.each{ field -> highlighter.fields(field, f -> f ) }

    // Tạo request tìm kiếm với các tham số
    SearchRequest request = SearchRequest.of(r -> r
      .query(query.build()._toQuery())
      .from(start)
      .size(rows)
      .highlight(highlighter.build())
      .sort(s -> s
        .field(f -> f
          .field("time_create_dt")
          .order(SortOrder.Desc)  // Sắp xếp theo ngày tạo giảm dần
        )
      )
    )

    // Thực hiện tìm kiếm và xử lý kết quả
    def result = searchClient.search(request, Map)

    if (result && result.hits() && result.hits().hits()) {
      return processNewsSearchResults(result)  // Xử lý kết quả tìm kiếm với highlight
    } else {
      return []
    }
  }

  /**
   * Tìm kiếm tin tức với phạm vi tìm kiếm cụ thể (title, content, title+content, all)
   * @param userTerm - Từ khóa tìm kiếm của người dùng
   * @param categories - Danh mục cần lọc
   * @param scope - Phạm vi tìm kiếm (all, title, content, title_content)
   * @param start - Vị trí bắt đầu (mặc định 0)
   * @param rows - Số lượng kết quả (mặc định 50)
   * @return Danh sách tin tức phù hợp
   */
  def searchNewsWithScope(userTerm, categories, scope = 'all', start = DEFAULT_START, rows = DEFAULT_ROWS) {
    // Tạo query bool để kết hợp nhiều điều kiện tìm kiếm
    def query = new BoolQuery.Builder()

    // ===== BƯỚC 1: LỌC THEO LOẠI NỘI DUNG =====
    // Chỉ lấy các document có content-type là tin tức
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v
          .stringValue(ITEM_NEW_CONTENT_TYPE)
        )
      )
    )

    // ===== BƯỚC 2: LỌC THEO ĐƯỜNG DẪN =====
    // Chỉ lấy tin tức từ thư mục /list-blog
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + LIST_BLOG_PATH + "*")
      )
    )

    // ===== BƯỚC 3: LỌC THEO DANH MỤC (NẾU CÓ) =====
    // Nếu người dùng chọn danh mục cụ thể, thêm filter theo danh mục
    if (categories) {
      query.filter(getFieldQueryWithMultipleValues("categorys_o.item.key", categories))
    }

          // ===== BƯỚC 4: XỬ LÝ TỪ KHÓA TÌM KIẾM VỚI PHẠM VI =====
      if (userTerm) {
        // Xác định các trường tìm kiếm dựa trên scope
        def searchFields = []
        def highlightFields = []
        
        switch (scope) {
          case 'title':
            // Chỉ tìm kiếm trong tiêu đề
            searchFields = ['title_vi_s^2.0', 'title_en_s^1.5']
            highlightFields = ['title_vi_s', 'title_en_s']
            break
          case 'content':
            // Chỉ tìm kiếm trong nội dung
            searchFields = ['content_vi_html^1.0', 'content_en_html^1.0']
            highlightFields = ['content_vi_html', 'content_en_html']
            break
          case 'title_content':
            // Tìm kiếm trong tiêu đề và nội dung (ưu tiên tiêu đề)
            searchFields = ['title_vi_s^2.0', 'title_en_s^1.5', 'content_vi_html^1.0', 'content_en_html^1.0']
            highlightFields = ['title_vi_s', 'title_en_s', 'content_vi_html', 'content_en_html']
            break
          default:
            // Tìm kiếm tất cả (mặc định)
            searchFields = ITEM_NEW_SEARCH_FIELDS
            highlightFields = HIGHLIGHT_FIELDS
            break
        }

        // Kiểm tra xem người dùng có yêu cầu tìm kiếm chính xác với dấu ngoặc kép không
        def matcher = userTerm =~ /.*("([^"]+)").*/
        if (matcher.matches()) {
          // Sử dụng MUST để bắt buộc phải có kết quả khớp với cụm từ trong ngoặc kép
          query.must(q -> q
            .multiMatch(m -> m
              .query(matcher.group(2))  // Lấy phần text trong ngoặc kép
              .fields(searchFields)
              .fuzzyTranspositions(false)
              .autoGenerateSynonymsPhraseQuery(false)
            )
          )

          // Xóa phần tìm kiếm chính xác để tiếp tục xử lý phần còn lại
          userTerm = StringUtils.remove(userTerm, matcher.group(1))
        }

        // ===== BƯỚC 5: XỬ LÝ PHẦN TỪ KHÓA CÒN LẠI VỚI TÌM KIẾM TƯƠNG ĐỐI =====
        if (userTerm) {
          // Tìm kiếm phrase prefix với boost cao nhất
          query.should(q -> q
            .multiMatch(m -> m
              .query(userTerm)
              .fields(searchFields)
              .type(TextQueryType.PhrasePrefix)
              .boost(2.0f)
            )
          )
          // Tìm kiếm match với operator OR (tương đối hơn)
          query.should(q -> q
            .multiMatch(m -> m
              .query(userTerm)
              .fields(searchFields)
              .operator(org.opensearch.client.opensearch._types.query_dsl.Operator.Or)
              .boost(1.5f)
            )
          )
          // Tìm kiếm fuzzy để bắt lỗi chính tả
          query.should(q -> q
            .multiMatch(m -> m
              .query(userTerm)
              .fields(searchFields)
              .fuzziness("AUTO")
              .boost(1.0f)
            )
          )
          // Tìm kiếm wildcard để bắt các từ có chứa từ khóa
          searchFields.each { field ->
            def cleanField = field.replaceAll(/\^[0-9.]+/, '') // Loại bỏ boost suffix
            query.should(q -> q
              .wildcard(w -> w
                .field(cleanField)
                .value("*" + userTerm + "*")
                .caseInsensitive(true)
                .boost(0.8f)
              )
            )
          }
        }

      // Cấu hình highlight để làm nổi bật từ khóa tìm kiếm
      def highlighter = new Highlight.Builder();
      highlightFields.each{ field -> highlighter.fields(field, f -> f ) }

      // Tạo request tìm kiếm với các tham số
      SearchRequest request = SearchRequest.of(r -> r
        .query(query.build()._toQuery())
        .from(start)
        .size(rows)
        .highlight(highlighter.build())
        .sort(s -> s
          .field(f -> f
            .field("createdDate_dt")
            .order(SortOrder.Desc)  // Sắp xếp theo ngày tạo giảm dần
          )
        )
      )

      // Thực hiện tìm kiếm và xử lý kết quả
      def result = searchClient.search(request, Map)

      if (result) {
        return processNewsSearchResults(result)  // Xử lý kết quả tìm kiếm với highlight
      } else {
        return []
      }
    } else {
      // Nếu không có từ khóa tìm kiếm, trả về danh sách rỗng
      return []
    }
  }

  /**
   * Lấy tất cả tin tức (không có filter tìm kiếm)
   * @param start - Vị trí bắt đầu
   * @param rows - Số lượng kết quả
   * @return Danh sách tất cả tin tức
   */
  def getAllNews(start = DEFAULT_START, rows = DEFAULT_ROWS) {
    def query = new BoolQuery.Builder()

    
    // ===== PHẦN 1: LỌC THEO LOẠI NỘI DUNG VÀ ĐƯỜNG DẪN =====
    // Lọc để chỉ lấy các bài viết có content-type là tin tức
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v
          .stringValue(ITEM_NEW_CONTENT_TYPE)
        )
      )
    )

    // Lọc theo đường dẫn - chỉ lấy các bài viết từ thư mục /list-blog
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + LIST_BLOG_PATH + "*")
      )
    )

    // ===== PHẦN 2: TẠO REQUEST TÌM KIẾM =====
    // Tạo yêu cầu tìm kiếm với các tham số: từ vị trí start, lấy rows kết quả
    // và sắp xếp theo ngày tạo giảm dần (mới nhất lên đầu)
    SearchRequest request = SearchRequest.of(r -> r
      .query(query.build()._toQuery())
      .from(start)
      .size(rows)
      .sort(s -> s
        .field(f -> f
          .field("time_create_dt")
          .order(SortOrder.Desc)
        )
      )
    )

    // ===== PHẦN 3: THỰC HIỆN TÌM KIẾM VÀ TRẢ VỀ KẾT QUẢ =====
    // Gọi API tìm kiếm và xử lý kết quả
    def result = searchClient.search(request, Map)

    if (result) {
      return processNewsListingResults(result)  // Xử lý và trả về danh sách tin tức
    } else {
      return []  // Trả về mảng rỗng nếu không có kết quả
    }
  }

  /**
   * Lấy tin tức theo danh mục (categories)
   * @param categories - Danh sách các danh mục cần lọc
   * @param start - Vị trí bắt đầu (mặc định 0)
   * @param rows - Số lượng kết quả (mặc định 10)
   * @return Danh sách tin tức theo danh mục
   */
  def getNewsByCategory(categories, start = DEFAULT_START, rows = DEFAULT_ROWS) {
    def query = new BoolQuery.Builder()

    // ===== PHẦN 1: LỌC THEO LOẠI NỘI DUNG VÀ ĐƯỜNG DẪN =====
    // Lọc để chỉ lấy các bài viết có content-type là tin tức
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v
          .stringValue(ITEM_NEW_CONTENT_TYPE)
        )
      )
    )

    // Lọc theo đường dẫn - chỉ lấy các bài viết từ thư mục /list-blog
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + LIST_BLOG_PATH + "*")
      )
    )

    // ===== PHẦN 2: LỌC THEO DANH MỤC =====
    // Nếu có danh mục được chỉ định, thêm điều kiện lọc theo danh mục
    if (categories) {
      query.filter(getFieldQueryWithMultipleValues("categorys_o.item.key", categories))
    }

    // ===== PHẦN 3: TẠO REQUEST VÀ THỰC HIỆN TÌM KIẾM =====
    SearchRequest request = SearchRequest.of(r -> r
      .query(query.build()._toQuery())
      .from(start)
      .size(rows)
      .sort(s -> s
        .field(f -> f
          .field("time_create_dt")
          .order(SortOrder.Desc)
        )
      )
    )

    def result = searchClient.search(request, Map)

    if (result) {
      return processNewsListingResults(result)
    } else {
      return []
    }
  }

  /**
   * Lấy tin tức theo key của danh mục (một danh mục cụ thể)
   * @param categoryKey - Key của danh mục cần lọc
   * @param start - Vị trí bắt đầu (mặc định 0)
   * @param rows - Số lượng kết quả (mặc định 10)
   * @return Danh sách tin tức theo key danh mục
   */
  def getNewsByCategoryKey(categoryKey, start = DEFAULT_START, rows = DEFAULT_ROWS) {
    def query = new BoolQuery.Builder()

    // ===== PHẦN 1: LỌC THEO LOẠI NỘI DUNG VÀ ĐƯỜNG DẪN =====
    // Lọc để chỉ lấy các bài viết có content-type là tin tức
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v
          .stringValue(ITEM_NEW_CONTENT_TYPE)
        )
      )
    )

    // Lọc theo đường dẫn - chỉ lấy các bài viết từ thư mục /list-blog
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + LIST_BLOG_PATH + "*")
      )
    )

    // ===== PHẦN 2: LỌC THEO KEY DANH MỤC =====
    // Nếu có categoryKey được chỉ định, thêm điều kiện lọc theo key danh mục
    if (categoryKey) {
      query.filter(q -> q
        .match(m -> m
          .field("categorys_o.item.key")
          .query(v -> v.stringValue(categoryKey))
        )
      )
    }

    // ===== PHẦN 3: TẠO REQUEST VÀ THỰC HIỆN TÌM KIẾM =====
    SearchRequest request = SearchRequest.of(r -> r
      .query(query.build()._toQuery())
      .from(start)
      .size(rows)
      .sort(s -> s
        .field(f -> f
          .field("time_create_dt")
          .order(SortOrder.Desc)
        )
      )
    )

    def result = searchClient.search(request, Map)

    if (result) {
      return processNewsListingResults(result)
    } else {
      return []
    }
  }

  /**
   * Tìm kiếm tin tức chỉ theo tiêu đề (title_vi_s hoặc title_en_s tùy ngôn ngữ)
   * @param userTerm - Từ khóa tìm kiếm
   * @param categories - Danh mục cần lọc
   * @param lang - 'vi' hoặc 'en'
   * @param start - Vị trí bắt đầu
   * @param rows - Số lượng kết quả
   * @return Danh sách tin tức phù hợp
   */
  def searchNewsByTitle(userTerm, categories, lang = 'vi', start = DEFAULT_START, rows = DEFAULT_ROWS) {
    def query = new BoolQuery.Builder()
    // Lọc loại nội dung
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v.stringValue(ITEM_NEW_CONTENT_TYPE))
      )
    )
    // Lọc theo đường dẫn
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + LIST_BLOG_PATH + "*")
      )
    )
    // Lọc theo danh mục nếu có
    if (categories && categories.size() > 0) {
      query.filter(getFieldQueryWithMultipleValues("categorys_o.item.key", categories))
    }
    // Chỉ tìm kiếm theo tiêu đề đúng ngôn ngữ với tìm kiếm tương đối
    def searchField = (lang == 'en') ? 'title_en_s' : 'title_vi_s'
    if (userTerm && userTerm.trim() != "") {
      // Tìm kiếm phrase prefix (từ khóa bắt đầu)
      query.should(q -> q
        .matchPhrasePrefix(m -> m
          .field(searchField)
          .query(userTerm)
          .caseInsensitive(true)
          .boost(2.0f)
        )
      )
      // Tìm kiếm match với operator OR (tương đối hơn)
      query.should(q -> q
        .match(m -> m
          .field(searchField)
          .query(v -> v.stringValue(userTerm))
          .operator(org.opensearch.client.opensearch._types.query_dsl.Operator.Or)
          .caseInsensitive(true)
          .boost(1.5f)
        )
      )
      // Tìm kiếm fuzzy để bắt lỗi chính tả
      query.should(q -> q
        .fuzzy(f -> f
          .field(searchField)
          .value(userTerm)
          .fuzziness("AUTO")
          .caseInsensitive(true)
          .boost(1.0f)
        )
      )
      // Tìm kiếm wildcard để bắt các từ có chứa từ khóa
      query.should(q -> q
        .wildcard(w -> w
          .field(searchField)
          .value("*" + userTerm + "*")
          .caseInsensitive(true)
          .boost(0.8f)
        )
      )
    }
    SearchRequest request = SearchRequest.of(r -> r
      .query(query.build()._toQuery())
      .from(start)
      .size(rows)
      .sort(s -> s
        .field(f -> f
          .field("time_create_dt")
          .order(SortOrder.Desc)
        )
      )
    )
    try {
      def result = searchClient.search(request, Map)
      if (result && result.hits() && result.hits().hits()) {
        return processNewsListingResults(result)
      } else {
        return []
      }
    } catch (Exception e) {
      return []
    }
  }

  /**
   * Tìm kiếm nâng cao cho bài viết (news) với hỗ trợ fuzzy, case-insensitive, lọc theo category, title, content, v.v.
   * @param searchParams Map chứa các tham số tìm kiếm (title, content, category)
   * @param start Vị trí bắt đầu
   * @param rows Số lượng bản ghi
   * @param sort Tham số sắp xếp (newest, oldest, a_to_z, z_to_a)
   * @param lang Ngôn ngữ ('vi' hoặc 'en')
   * @return Danh sách kết quả tìm kiếm
   */
  def searchNewsAdvanced(Map searchParams = [:], int start = DEFAULT_START, int rows = DEFAULT_ROWS, String sort = "newest", String lang = "vi") {
    try {
      def queryBuilder = new BoolQuery.Builder()
      // Filter by content-type
      queryBuilder.filter(q -> q
        .match(m -> m
          .field("content-type")
          .query(v -> v.stringValue(ITEM_NEW_CONTENT_TYPE))
        )
      )
      // Filter by path
      queryBuilder.filter(q -> q
        .wildcard(w -> w
          .field("localId")
          .value("*" + LIST_BLOG_PATH + "*")
        )
      )
      def searchFieldsBool = new BoolQuery.Builder()
      def hasSearchParams = false
      // Tìm kiếm theo tiêu đề
      if (searchParams.title) {
        hasSearchParams = true
        def field = (lang == 'en') ? 'title_en_s' : 'title_vi_s'
        searchFieldsBool.should(s -> s
          .regexp(r -> r
            .field(field)
            .value(".*${searchParams.title}.*")
            .caseInsensitive(true)
          )
        )
      }
      // Tìm kiếm theo nội dung
      if (searchParams.content) {
        hasSearchParams = true
        def field = (lang == 'en') ? 'content_en_html' : 'content_vi_html'
        searchFieldsBool.should(s -> s
          .regexp(r -> r
            .field(field)
            .value(".*${searchParams.content}.*")
            .caseInsensitive(true)
          )
        )
      }
      // Tìm kiếm theo danh mục (category)
      if (searchParams.category) {
        hasSearchParams = true
        searchFieldsBool.should(s -> s
          .match(m -> m
            .field("categorys_o.item.key")
            .query(v -> v.stringValue(searchParams.category))
            .analyzer(MULTIPLE_VALUES_SEARCH_ANALYZER)
          )
        )
      }
      if (hasSearchParams) {
        queryBuilder.must(b -> b.bool(searchFieldsBool.build()))
      }
      // Sắp xếp
      def sortField
      def sortOrder
      switch (sort) {
        case "oldest":
          sortField = "time_create_dt"; sortOrder = SortOrder.Asc; break
        case "a_to_z":
          sortField = (lang == 'en') ? "title_en_s.keyword" : "title_vi_s.keyword"; sortOrder = SortOrder.Asc; break
        case "z_to_a":
          sortField = (lang == 'en') ? "title_en_s.keyword" : "title_vi_s.keyword"; sortOrder = SortOrder.Desc; break
        case "newest":
        default:
          sortField = "time_create_dt"; sortOrder = SortOrder.Desc; break
      }
      def searchRequest = SearchRequest.of(r -> r
        .query(queryBuilder.build()._toQuery())
        .from(start)
        .size(rows)
        .sort(s -> s.field(f -> f.field(sortField).order(sortOrder)))
      )
      def result = searchClient.search(searchRequest, Map)
      if (result) {
        return processNewsListingResults(result)
      } else {
        return []
      }
    } catch (Exception e) {
      return []
    }
  }

  /**
   * Đếm tổng số bài viết phù hợp với điều kiện tìm kiếm
   * @param searchParams Map chứa các tham số tìm kiếm
   * @param lang Ngôn ngữ ('vi' hoặc 'en')
   * @return Số lượng bài viết phù hợp
   */
  def getTotalNews(Map searchParams = [:], String lang = "vi") {
    try {
      def queryBuilder = new BoolQuery.Builder()
      // Filter by content-type
      queryBuilder.filter(q -> q
        .match(m -> m
          .field("content-type")
          .query(v -> v.stringValue(ITEM_NEW_CONTENT_TYPE))
        )
      )
      // Filter by path
      queryBuilder.filter(q -> q
        .wildcard(w -> w
          .field("localId")
          .value("*" + LIST_BLOG_PATH + "*")
        )
      )
      def searchFieldsBool = new BoolQuery.Builder()
      def hasSearchParams = false
      if (searchParams.title) {
        hasSearchParams = true
        def field = (lang == 'en') ? 'title_en_s' : 'title_vi_s'
        searchFieldsBool.should(s -> s
          .regexp(r -> r
            .field(field)
            .value(".*${searchParams.title}.*")
            .caseInsensitive(true)
          )
        )
      }
      if (searchParams.content) {
        hasSearchParams = true
        def field = (lang == 'en') ? 'content_en_html' : 'content_vi_html'
        searchFieldsBool.should(s -> s
          .regexp(r -> r
            .field(field)
            .value(".*${searchParams.content}.*")
            .caseInsensitive(true)
          )
        )
      }
      if (searchParams.category) {
        hasSearchParams = true
        searchFieldsBool.should(s -> s
          .match(m -> m
            .field("categorys_o.item.key")
            .query(v -> v.stringValue(searchParams.category))
            .analyzer(MULTIPLE_VALUES_SEARCH_ANALYZER)
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
      return 0
    }
  }

  /**
   * Xử lý kết quả tìm kiếm tin tức (có highlight từ khóa)
   * @param result - Kết quả tìm kiếm từ Elasticsearch
   * @return Danh sách tin tức đã được xử lý
   */
  private def processNewsSearchResults(result) {
    def news = []
    def hits = result.hits().hits()

    if (hits) {
      hits.each {hit ->
        def doc = hit.source()
        def newsItem = [:]
        
        // ===== PHẦN 1: LẤY THÔNG TIN CƠ BẢN CỦA TIN TỨC =====
        newsItem.id = doc.objectId
        newsItem.objectId = doc.objectId
        newsItem.path = doc.localId
        newsItem.title = doc.title_vi_s ?: doc.title_en_s  // Ưu tiên tiếng Việt, nếu không có thì dùng tiếng Anh
        newsItem.title_vi = doc.title_vi_s
        newsItem.title_en = doc.title_en_s
        newsItem.content_vi = doc.content_vi_html
        newsItem.content_en = doc.content_en_html
        newsItem.internal_name = doc.internal_name
        newsItem.nav_label = doc.navLabel
        newsItem.url = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)
        newsItem.url_en = newsItem.url + (newsItem.url.contains('?') ? '&' : '?') + 'lang=en'
        newsItem.created_date = convertToHanoiTimeString(doc.time_create_dt, doc.time_create_dt_tz)
        newsItem.last_modified_date = convertToHanoiTimeString(doc.lastModifiedDate_dt)
        newsItem.img_main_s = doc.img_main_s

        // ===== PHẦN 2: XỬ LÝ DANH MỤC =====
        // Trích xuất danh mục từ trường categorys_o.item.key
        // ===== PHẦN 1: XỬ LÝ DANH MỤC (CATEGORIES) =====
        // Kiểm tra xem tin tức có thông tin danh mục không
        if (doc.categorys_o && doc.categorys_o.item) {
          // Khởi tạo mảng rỗng để lưu danh sách danh mục
          newsItem.categories = []
          
          // Kiểm tra xem danh mục có phải là danh sách nhiều item không
          if (doc.categorys_o.item instanceof List) {
            // Nếu có nhiều danh mục (dạng list) - duyệt qua từng danh mục
            doc.categorys_o.item.each { category ->
              // Thêm key của danh mục vào danh sách
              newsItem.categories << category.key
            }
          } else {
            // Nếu chỉ có 1 danh mục duy nhất - thêm trực tiếp
            newsItem.categories << doc.categorys_o.item.key
          }
        }

        // ===== PHẦN 2: XỬ LÝ HIGHLIGHT (LÀM NỔI BẬT TỪ KHÓA TÌM KIẾM) =====
        // Kiểm tra xem có highlight từ khóa tìm kiếm không
        if (hit.highlight()) {
          // Lấy tất cả các giá trị highlight từ kết quả tìm kiếm
          def newsHighlights = hit.highlight().values()
          if (newsHighlights) {
            // Khởi tạo mảng để lưu tất cả các đoạn highlight
            def highlightValues = []

            // Duyệt qua từng loại highlight (title, content, etc.)
            newsHighlights.each { value ->
              // Thêm tất cả các đoạn highlight vào mảng
              highlightValues.addAll(value)
            }

            // Nối các đoạn highlight bằng dấu "..." và loại bỏ khoảng trắng thừa
            newsItem.highlight = StringUtils.join(highlightValues, "... ")
            newsItem.highlight = StringUtils.strip(newsItem.highlight)
          }
        }

        // Thêm tin tức đã xử lý vào danh sách kết quả
        news << newsItem
      }
    }

    // Trả về danh sách tin tức đã được xử lý
    return news
  }

  /**
   * Xử lý kết quả danh sách tin tức (không có highlight)
   * @param result - Kết quả tìm kiếm từ Elasticsearch
   * @return Danh sách tin tức đã được xử lý
   */
  private def processNewsListingResults(result) {
    // Khởi tạo mảng rỗng để lưu danh sách tin tức
    def news = []
    // Lấy tất cả các document từ kết quả tìm kiếm
    def documents = result.hits().hits()*.source()

    // Kiểm tra xem có document nào không
    if (documents) {
      // Duyệt qua từng document (tin tức)
      documents.each {doc ->
        // Khởi tạo object rỗng để lưu thông tin tin tức
        def newsItem = [:]
        
        // ===== PHẦN 1: LẤY THÔNG TIN CƠ BẢN CỦA TIN TỨC =====
        newsItem.id = doc.objectId                    // ID của tin tức
        newsItem.objectId = doc.objectId              // ID object
        newsItem.path = doc.localId                   // Đường dẫn file
        newsItem.storeUrl = doc.localId               // URL gốc trong store
        newsItem.title = doc.title_vi_s ?: doc.title_en_s  // Tiêu đề (ưu tiên tiếng Việt)
        newsItem.title_vi = doc.title_vi_s            // Tiêu đề tiếng Việt
        newsItem.title_en = doc.title_en_s            // Tiêu đề tiếng Anh
        newsItem.content_vi = doc.content_vi_html     // Nội dung tiếng Việt
        newsItem.content_en = doc.content_en_html     // Nội dung tiếng Anh
        newsItem.internal_name = doc.internal_name    // Tên nội bộ
        newsItem.nav_label = doc.navLabel             // Nhãn navigation
        newsItem.url = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)  // URL hiển thị
        newsItem.url_en = newsItem.url + (newsItem.url.contains('?') ? '&' : '?') + 'lang=en'
        newsItem.created_date = convertToHanoiTimeString(doc.time_create_dt, doc.time_create_dt_tz)      // Ngày tạo (giờ Hà Nội)
        newsItem.last_modified_date = convertToHanoiTimeString(doc.lastModifiedDate_dt)  // Ngày sửa cuối
        newsItem.img_main_s = doc.img_main_s          // Hình ảnh chính

        // ===== PHẦN 2: XỬ LÝ DANH MỤC =====
        // Trích xuất danh mục từ trường categorys_o.item.key
        if (doc.categorys_o && doc.categorys_o.item) {
          newsItem.categories = []
          if (doc.categorys_o.item instanceof List) {
            // Nếu có nhiều danh mục (dạng list) - duyệt qua từng danh mục
            doc.categorys_o.item.each { category ->
              newsItem.categories << category.key
            }
          } else {
            // Nếu chỉ có 1 danh mục duy nhất - thêm trực tiếp
            newsItem.categories << doc.categorys_o.item.key
          }
        }

        // Thêm tin tức đã xử lý vào danh sách kết quả
        news << newsItem
      }
    }

    // Trả về danh sách tin tức đã được xử lý
    return news
  }

  /**
   * Tạo query tìm kiếm với nhiều giá trị cho một trường
   * @param field - Tên trường cần tìm kiếm
   * @param values - Giá trị cần tìm (có thể là array, list, hoặc string)
   * @return Query object để tìm kiếm
   */
  private Query getFieldQueryWithMultipleValues(field, values) {
    // ===== PHẦN 1: CHUẨN HÓA DỮ LIỆU ĐẦU VÀO =====
    // Kiểm tra nếu values là array thì chuyển thành List
    if (values.class.isArray()) {
      values = values as List
    }

    // Kiểm tra nếu values là Iterable (List, Set, etc.) thì nối thành string
    if (values instanceof Iterable) {
      values = StringUtils.join((Iterable)values, " ") as String
    } else {
      // Nếu không phải Iterable thì chuyển thành String
      values = values as String
    }

    // ===== PHẦN 2: TẠO QUERY TÌM KIẾM =====
    // Tạo query match với analyzer đặc biệt để xử lý nhiều giá trị
    return Query.of(q -> q
      .match(m -> m
        .field(field)                    // Trường cần tìm kiếm
        .query(v -> v
          .stringValue(values)           // Giá trị cần tìm
        )
        .analyzer(MULTIPLE_VALUES_SEARCH_ANALYZER)  // Sử dụng analyzer đặc biệt
      )
    );
  }

  /**
   * Chuyển đổi thời gian từ timezone được chỉ định sang giờ Hà Nội
   * @param date - Thời gian cần chuyển đổi (có thể là String hoặc ZonedDateTime)
   * @param timezone - Timezone của thời gian (nếu null thì mặc định là UTC)
   * @return String thời gian theo định dạng dd/MM/yyyy HH:mm (giờ Hà Nội)
   */
  private def convertToHanoiTimeString(date, timezone = null) {
    // Kiểm tra nếu date rỗng thì trả về chuỗi rỗng
    if (!date) return ""
    
    try {
      // ===== PHẦN 1: CHUYỂN ĐỔI THỜI GIAN =====
      // Nếu date là String thì parse thành ZonedDateTime, nếu không thì dùng trực tiếp
      def sourceDateTime = (date instanceof String) ? ZonedDateTime.parse(date) : date
      
      // Xác định timezone nguồn
      def sourceZone = timezone ? ZoneId.of(timezone) : ZoneId.of("UTC")
      
      // Nếu sourceDateTime chưa có timezone, gán timezone cho nó
      if (sourceDateTime.zone == ZoneId.of("Z")) {
        sourceDateTime = sourceDateTime.withZoneSameInstant(sourceZone)
      }
      
      // Chuyển từ timezone nguồn sang múi giờ Hà Nội (Asia/Bangkok)
      def hanoi = sourceDateTime.withZoneSameInstant(ZoneId.of("Asia/Bangkok"))
      
      return hanoi.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
    } catch (Exception e) {
      return ""
    }
  }

}
