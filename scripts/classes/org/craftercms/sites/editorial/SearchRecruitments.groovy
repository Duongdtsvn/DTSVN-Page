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
  // ^2.0 = độ ưu tiên cao nhất, ^1.5 = ưu tiên trung bình, ^1.0 = ưu tiên thấp
  static final List<String> ITEM_RECRUITMENT_SEARCH_FIELDS = [
    'title_vi_s^2.0',      // Tiêu đề tiếng Việt (ưu tiên cao nhất)
    'title_en_s^2.0',      // Tiêu đề tiếng Anh (ưu tiên cao nhất)
    'description_vi_t^1.5', // Mô tả tiếng Việt (ưu tiên trung bình)
    'description_en_t^1.5', // Mô tả tiếng Anh (ưu tiên trung bình)
    'internal_name^1.0'    // Tên nội bộ (ưu tiên thấp)
  ]
  
  // Cấu hình phân trang mặc định
  static final int DEFAULT_START = 0
  static final int DEFAULT_ROWS = 10
  
  // Analyzer sử dụng cho tìm kiếm nhiều giá trị
  static final String MULTIPLE_VALUES_SEARCH_ANALYZER = Analyzer.Kind.Whitespace.jsonValue()
  
  // Định dạng ngày giờ
  static final String DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
  static final String HANOI_TIMEZONE = "Asia/Ho_Chi_Minh"
  
  // ===== CÁC THÀNH PHẦN CHÍNH =====
  OpenSearchClientWrapper elasticsearch
  UrlTransformationService urlTransformationService

  SearchRecruitments(OpenSearchClientWrapper elasticsearch, UrlTransformationService urlTransformationService) {
    this.elasticsearch = elasticsearch
    this.urlTransformationService = urlTransformationService
  }

  /**
   * Lấy tất cả tin tuyển dụng với phân trang và sắp xếp
   */
  def getAllRecruitments(start = DEFAULT_START, rows = DEFAULT_ROWS, orderBy = "time_create_dt", orderType = SortOrder.DESC) {
    def recruitmentItems = []
    
    // Build the Elasticsearch query
    def queryBuilder = new BoolQuery.Builder()
    queryBuilder.must(q -> q
      .term(t -> t
        .field("content-type")
        .value(ITEM_RECRUITMENT_CONTENT_TYPE)
      )
    )
    
    def searchRequest = new SearchRequest.Builder()
      .query(queryBuilder.build()._toQuery())
      .sort(s -> s
        .field(f -> f
          .field(orderBy)
          .order(orderType)
        )
      )
      .from(start)
      .size(rows)
      .index("editorial")
      .build()
      
    // Execute query
    def result = elasticsearch.search(searchRequest)
    
    // Process results
    def documents = result.hits().hits()*.source()
    
    if (documents) {
      documents.each { doc ->
        def recruitmentItem = [:]
        
        // ===== PHẦN 1: THÔNG TIN CƠ BẢN =====
        recruitmentItem.id = doc.objectId
        recruitmentItem.objectId = doc.objectId
        recruitmentItem.path = doc.localId
        recruitmentItem.storeUrl = doc.localId
        recruitmentItem.title = doc.title_vi_s ?: doc.title_en_s
        recruitmentItem.title_vi = doc.title_vi_s
        recruitmentItem.title_en = doc.title_en_s
        recruitmentItem.description = doc.description_vi_t
        recruitmentItem.description_en = doc.description_en_t
        recruitmentItem.internal_name = doc.internal_name
        
        // ===== PHẦN 2: URL =====
        recruitmentItem.url = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)
        recruitmentItem.url_en = recruitmentItem.url + (recruitmentItem.url.contains('?') ? '&' : '?') + 'lang=en'
        
        // ===== PHẦN 3: THỜI GIAN =====
        recruitmentItem.created_date = convertToHanoiTimeString(doc.time_create_dt)
        recruitmentItem.last_modified_date = convertToHanoiTimeString(doc.lastModifiedDate_dt)
        
        // ===== PHẦN 4: HÌNH ẢNH =====
        recruitmentItem.img_main_s = doc.img_main_s
        
        recruitmentItems << recruitmentItem
      }
    }
    
    return recruitmentItems
  }

  /**
   * Tìm kiếm tin tuyển dụng theo từ khóa
   */
  def searchRecruitments(String keywords) {
    def recruitmentItems = []
    
    if (StringUtils.isNotEmpty(keywords)) {
      def queryBuilder = new BoolQuery.Builder()
      
      // Tìm theo content type
      queryBuilder.must(q -> q
        .term(t -> t
          .field("content-type")
          .value(ITEM_RECRUITMENT_CONTENT_TYPE)
        )
      )
      
      // Tìm theo từ khóa trong các trường
      ITEM_RECRUITMENT_SEARCH_FIELDS.each { field ->
        queryBuilder.should(q -> q
          .match(m -> m
            .field(field)
            .query(keywords)
            .analyzer("standard")
            .type(TextQueryType.BestFields)
            .boost(field.endsWith("^2.0") ? 2.0f : field.endsWith("^1.5") ? 1.5f : 1.0f)
          )
        )
      }
      queryBuilder.minimumShouldMatch("1")
      
      def searchRequest = new SearchRequest.Builder()
        .query(queryBuilder.build()._toQuery())
        .sort(s -> s
          .field(f -> f
            .field("time_create_dt")
            .order(SortOrder.DESC)
          )
        )
        .index("editorial")
        .build()
        
      def result = elasticsearch.search(searchRequest)
      def documents = result.hits().hits()*.source()
      
      if (documents) {
        documents.each { doc ->
          def recruitmentItem = [:]
          
          // ===== PHẦN 1: THÔNG TIN CƠ BẢN =====
          recruitmentItem.id = doc.objectId
          recruitmentItem.objectId = doc.objectId
          recruitmentItem.path = doc.localId
          recruitmentItem.storeUrl = doc.localId
          recruitmentItem.title = doc.title_vi_s ?: doc.title_en_s
          recruitmentItem.title_vi = doc.title_vi_s
          recruitmentItem.title_en = doc.title_en_s
          recruitmentItem.description = doc.description_vi_t
          recruitmentItem.description_en = doc.description_en_t
          recruitmentItem.internal_name = doc.internal_name
          
          // ===== PHẦN 2: URL =====
          recruitmentItem.url = urlTransformationService.transform("storeUrlToRenderUrl", doc.localId)
          recruitmentItem.url_en = recruitmentItem.url + (recruitmentItem.url.contains('?') ? '&' : '?') + 'lang=en'
          
          // ===== PHẦN 3: THỜI GIAN =====
          recruitmentItem.created_date = convertToHanoiTimeString(doc.time_create_dt)
          recruitmentItem.last_modified_date = convertToHanoiTimeString(doc.lastModifiedDate_dt)
          
          // ===== PHẦN 4: HÌNH ẢNH =====
          recruitmentItem.img_main_s = doc.img_main_s
          
          recruitmentItems << recruitmentItem
        }
      }
    }
    
    return recruitmentItems
  }

  /**
   * Chuyển đổi thời gian sang múi giờ Hà Nội
   */
  private String convertToHanoiTimeString(String dateStr) {
    if (!dateStr) return null
    
    def date = ZonedDateTime.parse(dateStr, DateTimeFormatter.ofPattern(DATE_TIME_FORMAT))
    def hanoiZone = ZoneId.of(HANOI_TIMEZONE)
    def hanoiDate = date.withZoneSameInstant(hanoiZone)
    
    return hanoiDate.format(DateTimeFormatter.ofPattern(DATE_TIME_FORMAT))
  }
}