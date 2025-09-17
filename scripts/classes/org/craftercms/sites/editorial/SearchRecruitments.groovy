package org.craftercms.sites.editorial

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
 * Class SearchRecruitments - Quản lý tìm kiếm và lấy dữ liệu tuyển dụng từ OpenSearch
 * Chức năng chính: tìm kiếm tin tuyển dụng, lấy tất cả tin tuyển dụng
 */
class SearchRecruitments {

  // ===== CÁC HẰNG SỐ CẤU HÌNH =====
  
  // Định nghĩa loại nội dung tuyển dụng để lọc dữ liệu
  static final String ITEM_RECRUITMENT_CONTENT_TYPE = "/page/item-recruitment"
  
  // Đường dẫn thư mục chứa tin tuyển dụng
  static final String RECRUITMENT_PATH = "/site/website/recruitment"
  
  // Các trường dữ liệu để tìm kiếm với độ ưu tiên khác nhau
  static final List<String> ITEM_RECRUITMENT_SEARCH_FIELDS = [
    'title_vi_s^2.0',      // Tiêu đề tiếng Việt (ưu tiên cao nhất)
    'content_vi_html^1.0',  // Nội dung tiếng Việt
    'title_en_s^2.0',      // Tiêu đề tiếng Anh 
    'content_en_html^1.0'   // Nội dung tiếng Anh
  ]

  // Các dịch vụ được inject
  OpenSearchClientWrapper searchClient
  UrlTransformationService urlTransformationService
  
  /**
   * Constructor mặc định
   */
  SearchRecruitments(OpenSearchClientWrapper searchClient, UrlTransformationService urlTransformationService) {
    this.searchClient = searchClient
    this.urlTransformationService = urlTransformationService
  }

  /**
   * Lấy tất cả tin tuyển dụng với phân trang
   */
  def getAllRecruitments(start = 0, rows = 10) {
    def query = createBasicQuery()
    
    def builder = new SearchRequest.Builder()
    builder.query(query)
           .from(start)
           .size(rows)
           .highlight(createHighlight())
    
    def result = searchClient.search(builder.build())
    def recruitments = processSearchResults(result)
    
    return recruitments
  }

  /**
   * Tìm kiếm tin tuyển dụng theo từ khóa
   */
  def searchRecruitments(keywords, start = 0, rows = 10) {
    def query = createBasicQuery()
    
    if (keywords) {
      def multiMatchQuery = new Query.Builder()
        .multiMatch { m -> 
          m.query(keywords)
           .fields(ITEM_RECRUITMENT_SEARCH_FIELDS)
           .type(TextQueryType.CrossFields)
           .analyzer(Analyzer.Standard)
        }
        .build()
        
      query = query.must(multiMatchQuery)
    }
    
    def builder = new SearchRequest.Builder()
    builder.query(query)
           .from(start)
           .size(rows)
           .highlight(createHighlight())
           
    def result = searchClient.search(builder.build())
    def recruitments = processSearchResults(result)
    
    return recruitments
  }

  /**
   * Tạo query cơ bản cho tìm kiếm
   */
  private def createBasicQuery() {
    def queryBuilder = new Query.Builder()
    queryBuilder.bool { b ->
      b.must { must ->
        must.term { t ->
          t.field("content-type")
           .value(ITEM_RECRUITMENT_CONTENT_TYPE)
        }
      }
      b.must { must ->
        must.term { t ->
          t.field("localId")
           .value("*${RECRUITMENT_PATH}*")
        }
      }
    }
    return queryBuilder.build()
  }

  /**
   * Tạo highlight cho kết quả tìm kiếm
   */
  private def createHighlight() {
    return new Highlight.Builder()
      .preTags(["<strong>"])
      .postTags(["</strong>"])
      .fields("title_vi_s", new HashMap<>())
      .fields("content_vi_html", new HashMap<>())
      .fields("title_en_s", new HashMap<>())
      .fields("content_en_html", new HashMap<>())
      .build()
  }

  /**
   * Xử lý kết quả tìm kiếm
   */
  private def processSearchResults(result) {
    def recruitments = []
    def documents = result.hits().hits()*.source()

    if (documents) {
      documents.each { doc ->
        def recruitmentItem = [:]
        
        // ===== PHẦN 1: LẤY THÔNG TIN CƠ BẢN CỦA TIN TUYỂN DỤNG =====
        recruitmentItem.id = doc.objectId
        recruitmentItem.objectId = doc.objectId
        recruitmentItem.path = doc.localId
        recruitmentItem.storeUrl = doc.localId
        recruitmentItem.title = doc.title_vi_s ?: doc.title_en_s
        recruitmentItem.title_vi = doc.title_vi_s
        recruitmentItem.title_en = doc.title_en_s
        recruitmentItem.content_vi = doc.content_vi_html
        recruitmentItem.content_en = doc.content_en_html
        recruitmentItem.internal_name = doc.internal_name
        recruitmentItem.url = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)
        recruitmentItem.url_en = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId.replace(".xml", "-en.xml"))
        
        // ===== PHẦN 2: THÊM HÌNH ẢNH =====
        recruitmentItem.img_main = doc.img_main_s ?: "/static-assets/images/recruitments/default-recruitment.jpg"
        
        recruitments << recruitmentItem
      }
    }
    
    return recruitments
  }
}