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
 * Class SearchProjects - Quản lý tìm kiếm và lấy dữ liệu dự án từ OpenSearch
 * Chức năng chính: tìm kiếm dự án, lấy tất cả dự án
 */
class SearchProjects {

  // ===== CÁC HẰNG SỐ CẤU HÌNH =====
  // Định nghĩa loại nội dung dự án để lọc dữ liệu
  static final String ITEM_PROJECT_CONTENT_TYPE = "/page/item-project"
  
  // Đường dẫn thư mục chứa dự án
  static final String PROJECT_PATH = "/site/website/project"
  
  // Các trường dữ liệu để tìm kiếm với độ ưu tiên khác nhau
  // ^2.0 = độ ưu tiên cao nhất, ^1.5 = ưu tiên trung bình, ^1.0 = ưu tiên thấp
  static final List<String> ITEM_PROJECT_SEARCH_FIELDS = [
    'title_vi_s^2.0',      // Tiêu đề tiếng Việt (ưu tiên cao nhất)
    'info_main_t^1.0',     // Thông tin chính tiếng Việt
    'title_en_s^1.5',      // Tiêu đề tiếng Anh (ưu tiên trung bình)
    'info_main_en_t^1.0'   // Thông tin chính tiếng Anh
  ]
  
  // Các trường sẽ được highlight (làm nổi bật) khi tìm kiếm
  static final String[] HIGHLIGHT_FIELDS = ["title_vi_s", "info_main_t", "title_en_s", "info_main_en_t"]
  
  // Cấu hình mặc định cho phân trang
  static final int DEFAULT_START = 0    // Vị trí bắt đầu mặc định
  static final int DEFAULT_ROWS = 50    // Số lượng kết quả mặc định

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
  SearchProjects(OpenSearchClientWrapper searchClient, UrlTransformationService urlTransformationService) {
    this.searchClient = searchClient
    this.urlTransformationService = urlTransformationService
  }

  /**
   * Tìm kiếm dự án với từ khóa
   * @param userTerm - Từ khóa tìm kiếm của người dùng
   * @param start - Vị trí bắt đầu (mặc định 0)
   * @param rows - Số lượng kết quả (mặc định 50)
   * @return Danh sách dự án phù hợp
   */
  def searchProjects(userTerm, start = DEFAULT_START, rows = DEFAULT_ROWS) {
    // Tạo query bool để kết hợp nhiều điều kiện tìm kiếm
    def query = new BoolQuery.Builder()

    // ===== BƯỚC 1: LỌC THEO LOẠI NỘI DUNG =====
    // Chỉ lấy các document có content-type là dự án
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v
          .stringValue(ITEM_PROJECT_CONTENT_TYPE)
        )
      )
    )

    // ===== BƯỚC 2: LỌC THEO ĐƯỜNG DẪN =====
    // Chỉ lấy dự án từ thư mục /project
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + PROJECT_PATH + "*")
      )
    )

    // ===== BƯỚC 3: XỬ LÝ TỪ KHÓA TÌM KIẾM =====
    if (userTerm) {
      // Kiểm tra xem người dùng có yêu cầu tìm kiếm chính xác với dấu ngoặc kép không
      // Ví dụ: "từ khóa chính xác" sẽ tìm kiếm cụm từ này
      def matcher = userTerm =~ /.*("([^"]+)").*/
      if (matcher.matches()) {
        // Sử dụng MUST để bắt buộc phải có kết quả khớp với cụm từ trong ngoặc kép
        query.must(q -> q
          .multiMatch(m -> m
            .query(matcher.group(2))  // Lấy phần text trong ngoặc kép
            .fields(ITEM_PROJECT_SEARCH_FIELDS)
            .fuzzyTranspositions(false)
            .autoGenerateSynonymsPhraseQuery(false)
          )
        )

        // Xóa phần tìm kiếm chính xác để tiếp tục xử lý phần còn lại
        userTerm = StringUtils.remove(userTerm, matcher.group(1))
      } else {
        // Nếu không có ngoặc kép, yêu cầu ít nhất 1 từ khóa phải khớp
        query.minimumShouldMatch("1")
      }

      // ===== BƯỚC 4: XỬ LÝ PHẦN TỪ KHÓA CÒN LẠI =====
      if (userTerm) {
        // Sử dụng SHOULD để tạo tìm kiếm tùy chọn
        // Mỗi match thêm sẽ tăng điểm của document
        query
          // Tìm kiếm phrase match với wildcard ở cuối (boost 1.5)
          // Ví dụ: "dự án" sẽ tìm "dự án", "dự án mới", "dự án công nghệ"
          .should(q -> q
            .multiMatch(m -> m
              .query(userTerm)
              .fields(ITEM_PROJECT_SEARCH_FIELDS)
              .type(TextQueryType.PhrasePrefix)
              .boost(1.5f)  // Tăng điểm cho kết quả này
            )
          )
          // Tìm kiếm match trên các từ riêng lẻ
          .should(q -> q
            .multiMatch(m -> m
              .query(userTerm)
              .fields(ITEM_PROJECT_SEARCH_FIELDS)
            )
          )
      }
    }

    // Cấu hình highlight để làm nổi bật từ khóa tìm kiếm
    def highlighter = new Highlight.Builder();
    HIGHLIGHT_FIELDS.each{ field -> highlighter.fields(field, f -> f ) }

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

    if (result) {
      return processProjectSearchResults(result)  // Xử lý kết quả tìm kiếm với highlight
    } else {
      return []
    }
  }

  /**
   * Lấy tất cả dự án (không có filter tìm kiếm)
   * @param start - Vị trí bắt đầu
   * @param rows - Số lượng kết quả
   * @return Danh sách tất cả dự án
   */
  def getAllProjects(start = DEFAULT_START, rows = DEFAULT_ROWS) {
    def query = new BoolQuery.Builder()

    // ===== PHẦN 1: LỌC THEO LOẠI NỘI DUNG VÀ ĐƯỜNG DẪN =====
    // Lọc để chỉ lấy các bài viết có content-type là dự án
    query.filter(q -> q
      .match(m -> m
        .field("content-type")
        .query(v -> v
          .stringValue(ITEM_PROJECT_CONTENT_TYPE)
        )
      )
    )

    // Lọc theo đường dẫn - chỉ lấy các bài viết từ thư mục /project
    query.filter(q -> q
      .wildcard(w -> w
        .field("localId")
        .value("*" + PROJECT_PATH + "*")
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
      return processProjectListingResults(result)  // Xử lý và trả về danh sách dự án
    } else {
      return []  // Trả về mảng rỗng nếu không có kết quả
    }
  }

  /**
   * Xử lý kết quả tìm kiếm dự án (có highlight từ khóa)
   * @param result - Kết quả tìm kiếm từ Elasticsearch
   * @return Danh sách dự án đã được xử lý
   */
  private def processProjectSearchResults(result) {
    def projects = []
    def hits = result.hits().hits()

    if (hits) {
      hits.each {hit ->
        def doc = hit.source()
        def projectItem = [:]
        
        // ===== PHẦN 1: LẤY THÔNG TIN CƠ BẢN CỦA DỰ ÁN =====
        projectItem.id = doc.objectId
        projectItem.objectId = doc.objectId
        projectItem.path = doc.localId
        projectItem.title = doc.title_vi_s ?: doc.title_en_s  // Ưu tiên tiếng Việt, nếu không có thì dùng tiếng Anh
        projectItem.title_vi = doc.title_vi_s
        projectItem.title_en = doc.title_en_s
        projectItem.info_main = doc.info_main_t
        projectItem.info_main_en = doc.info_main_en_t
        projectItem.internal_name = doc.internal_name
        projectItem.nav_label = doc.navLabel
        projectItem.url = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)
        projectItem.url_en = projectItem.url + (projectItem.url.contains('?') ? '&' : '?') + 'lang=en'
        projectItem.created_date = convertToHanoiTimeString(doc.time_create_dt, doc.time_create_dt_tz)
        projectItem.last_modified_date = convertToHanoiTimeString(doc.lastModifiedDate_dt)
        projectItem.img_main_s = doc.img_main_s

        // ===== PHẦN 2: XỬ LÝ HIGHLIGHT (LÀM NỔI BẬT TỪ KHÓA TÌM KIẾM) =====
        if (hit.highlight()) {
          def projectHighlights = hit.highlight().values()
          if (projectHighlights) {
            def highlightValues = []

            projectHighlights.each { value ->
              highlightValues.addAll(value)
            }

            projectItem.highlight = StringUtils.join(highlightValues, "... ")
            projectItem.highlight = StringUtils.strip(projectItem.highlight)
          }
        }

        projects << projectItem
      }
    }

    return projects
  }

  /**
   * Xử lý kết quả danh sách dự án (không có highlight)
   * @param result - Kết quả tìm kiếm từ Elasticsearch
   * @return Danh sách dự án đã được xử lý
   */
  private def processProjectListingResults(result) {
    def projects = []
    def documents = result.hits().hits()*.source()

    if (documents) {
      documents.each {doc ->
        def projectItem = [:]
        
        // ===== PHẦN 1: LẤY THÔNG TIN CƠ BẢN CỦA DỰ ÁN =====
        projectItem.id = doc.objectId
        projectItem.objectId = doc.objectId
        projectItem.path = doc.localId
        projectItem.storeUrl = doc.localId
        projectItem.title = doc.title_vi_s ?: doc.title_en_s
        projectItem.title_vi = doc.title_vi_s
        projectItem.title_en = doc.title_en_s
        projectItem.info_main = doc.info_main_t
        projectItem.info_main_en = doc.info_main_en_t
        projectItem.internal_name = doc.internal_name
        projectItem.nav_label = doc.navLabel
        projectItem.url = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)
        projectItem.url_en = projectItem.url + (projectItem.url.contains('?') ? '&' : '?') + 'lang=en'
        projectItem.created_date = convertToHanoiTimeString(doc.time_create_dt, doc.time_create_dt_tz)
        projectItem.last_modified_date = convertToHanoiTimeString(doc.lastModifiedDate_dt)
        projectItem.img_main_s = doc.img_main_s

        projects << projectItem
      }
    }

    return projects
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
