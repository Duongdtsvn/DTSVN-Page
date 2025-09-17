<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-pageTitle style-2 style-blogDetail">
    <div class="sec-pageTitle__wrap">
        <ul class="sec-pageTitle__breadcrumb">
            <li><a href="/">Trang chủ</a></li>
            <li><span>Sản phẩm-dịch vụ</span></li>
        </ul>
        <div class="sec-pageTitle__content">
            <div class="container-custom">
                <div class="row">
                    <div class="col-lg-9 ">
                        <h1 class="sec-pageTitle__title fz-52">${contentModel.title_s!''}</h1>
                        <p class="sec-pageTitle__text">${contentModel.text_t!''}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section sec-productBox">
    <div class="container-custom">
        <div class="productbox-list">
            <#-- Kiểm tra có product để hiển thị không -->
            <#if productItems?? && (productItems?size > 0)>
                <#-- Lặp qua từng product -->
                <#list productItems as product>
                    <div class="item">
                        <div class="productbox hover">
                            <div class="productbox__inner">
                                <div class="group">
                                    <!-- Hiển thị thẻ (tags) -->
                                    <span class="productbox__subtitle">
                                        ${product.key_main_s!''}
                                    </span>
                                    <h3 class="productbox__title">
                                        <a href="${product.url!''}">${product.title_vi!''}</a>
                                    </h3>
                                </div>
                                <div class="productbox__btn">
                                    <a href="${product.url!''}" class="btn-text">
                                        Tìm hiểu thêm <span></span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            <#else>
                <!-- Hiển thị thông báo khi không có product -->
                <div class="col-12">
                    <div class="text-center py-5">
                        <h3>Không tìm thấy sản phẩm nào</h3>
                        <p>Vui lòng thử lại sau.</p>
                    </div>
                </div>
            </#if>
        </div>

        <#-- Phân trang - chỉ hiển thị khi có nhiều hơn 1 trang -->
        <#if totalPages?? && (totalPages > 1)>
            <div class="pagination">
                <nav class="navigation pagination" aria-label="Phân trang sản phẩm">
                    
                    <div class="nav-links">
                        <#-- Nút Previous -->
                        <#if hasPrevPage?? && hasPrevPage>
                            <a class="prev page-numbers" href="?page=${(currentPage!1) - 1}">← Previous</a>
                        </#if>
                        
                        <#-- Hiển thị các số trang -->
                        <#if pageNumbers?? && (pageNumbers?size > 0)>
                            <#-- Hiển thị dấu ... và số 1 nếu cần -->
                            <#if pageNumbers?first?number gt 1>
                                <#if pageNumbers?first?number gt 2>
                                    <a class="page-numbers" href="?page=1">1</a>
                                    <span class="page-numbers dots">…</span>
                                <#else>
                                    <a class="page-numbers" href="?page=1">1</a>
                                </#if>
                            </#if>
                            
                            <#-- Lặp qua các số trang -->
                            <#list pageNumbers as pageNum>
                                <#if (pageNum?number) == (currentPage!1)?number>
                                    <span aria-current="page" class="page-numbers current">${pageNum}</span>
                                <#else>
                                    <a class="page-numbers" href="?page=${pageNum}">${pageNum}</a>
                                </#if>
                            </#list>
                            
                            <#-- Hiển thị dấu ... và số trang cuối nếu cần -->
                            <#if pageNumbers?last?number lt (totalPages!1)?number>
                                <#if pageNumbers?last?number lt (totalPages!1)?number - 1>
                                    <span class="page-numbers dots">…</span>
                                    <a class="page-numbers" href="?page=${totalPages!1}">${totalPages!1}</a>
                                <#else>
                                    <a class="page-numbers" href="?page=${totalPages!1}">${totalPages!1}</a>
                                </#if>
                            </#if>
                        </#if>
                        <#if hasNextPage?? && hasNextPage>
                            <a class="next page-numbers" href="?page=${(currentPage!1) + 1}">Next →</a>
                        </#if>
                    </div>
                </nav>
            </div>
        </#if>

        <!-- Thông tin phân trang -->
        <#if totalItems?? && (totalItems > 0)>
            <div class="pagination-info text-center mt-3">
                <#assign fromItem = (((currentPage!1) - 1) * (itemsPerPage!6)) + 1 />
                <#assign toItem = ((currentPage!1) * (itemsPerPage!6) < (totalItems!0))?then((currentPage!1) * (itemsPerPage!6), (totalItems!0)) />
                <p>Hiển thị ${fromItem} - ${toItem} trong tổng số ${totalItems!0} sản phẩm</p>
            </div>
        </#if>
    </div>
</section>