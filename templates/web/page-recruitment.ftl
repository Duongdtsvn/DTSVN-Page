<#import "/templates/system/common/crafter.ftl" as crafter />

<!doctype html>
<html lang="vi">
    <head>
        <#include "/templates/web/fragments/head.ftl" />
        <@crafter.head/>
    </head>
    <body>
        <div id="wrapper">
            <!-- Main -->
            <div id="main">
                <div class="inner">
                    <!-- Header -->
                    <@renderComponent componentPath="/site/components/headers/header.xml" />

                    <!-- Banner -->
                    <section class="page-banner">
                        <div class="container-custom">
                            <div class="banner-content">
                                <h1>Cơ hội nghề nghiệp</h1>
                                <div class="banner-text">
                                    <p>Tham gia cùng chúng tôi để phát triển sự nghiệp của bạn</p>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Recruitments Section -->
                    <section class="section sec-projectFeature">
                        <div class="container-custom">
                            <div class="projectFeature-list">
                                <#-- Kiểm tra có tin tuyển dụng để hiển thị không -->
                                <#if recruitmentItems?? && (recruitmentItems?size > 0)>
                                    <#-- Lặp qua từng tin tuyển dụng -->
                                    <#list recruitmentItems as recruitment>
                                        <div class="projectFeature">
                                            <div class="row">
                                                <div class="col-md-5 col-xxxl-4">
                                                    <a href="${recruitment.url!''}" class="projectFeature__img" style="background-image: url('${(recruitment.img_main?? && (recruitment.img_main?length > 0))?then(recruitment.img_main, '/static-assets/images/recruitments/default-recruitment.jpg')}');">
                                                    </a>
                                                </div>
                                                <div class="col-md-7 col-xxxl-6">
                                                    <div class="projectFeature__body">
                                                        <h3 class="projectFeature__title">
                                                            <a href="${recruitment.url!''}">${recruitment.title!''}</a>
                                                        </h3>
                                                        <div class="projectFeature__text">
                                                            <#if recruitment.content_vi?? && (recruitment.content_vi!'') != ''>
                                                                ${recruitment.content_vi!''}
                                                            <#else>
                                                                <p>Thông tin đang được cập nhật...</p>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </#list>
                                <#else>
                                    <#-- Hiển thị thông báo khi không có tin tuyển dụng -->
                                    <div class="col-12">
                                        <div class="text-center py-5">
                                            <h3>Không có vị trí tuyển dụng nào</h3>
                                            <p>Vui lòng quay lại sau.</p>
                                        </div>
                                    </div>
                                </#if>

                                <#-- Phân trang - chỉ hiển thị khi có nhiều hơn 1 trang -->
                                <#if totalPages?? && (totalPages > 1)>
                                    <div class="pagination">
                                        <nav class="navigation pagination" aria-label="Pagination">
                                            <div class="nav-links">
                                                <#-- Nút Previous -->
                                                <#if hasPrevPage?? && hasPrevPage>
                                                    <a class="prev page-numbers" href="?page=${(currentPage!1) - 1}">← Trước</a>
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
                                                    
                                                    <#-- Hiển thị các số trang trong phạm vi -->
                                                    <#list pageNumbers as pageNo>
                                                        <#if pageNo == currentPage>
                                                            <span class="page-numbers current">${pageNo}</span>
                                                        <#else>
                                                            <a class="page-numbers" href="?page=${pageNo}">${pageNo}</a>
                                                        </#if>
                                                    </#list>
                                                    
                                                    <#-- Hiển thị dấu ... và số trang cuối nếu cần -->
                                                    <#if pageNumbers?last?number lt totalPages>
                                                        <#if pageNumbers?last?number lt (totalPages - 1)>
                                                            <span class="page-numbers dots">…</span>
                                                            <a class="page-numbers" href="?page=${totalPages}">${totalPages}</a>
                                                        <#else>
                                                            <a class="page-numbers" href="?page=${totalPages}">${totalPages}</a>
                                                        </#if>
                                                    </#if>
                                                </#if>
                                                
                                                <#-- Nút Next -->
                                                <#if hasNextPage?? && hasNextPage>
                                                    <a class="next page-numbers" href="?page=${(currentPage!1) + 1}">Sau →</a>
                                                </#if>
                                            </div>
                                        </nav>
                                    </div>
                                </#if>
                            </div>
                        </div>
                    </section>
                </div>
            </div>

            <!-- Sidebar -->
            <@renderComponent componentPath="/site/components/sidebars/sidebar.xml" />
        </div>

        <#include "/templates/web/fragments/scripts.ftl" />
        <@crafter.body_bottom />
    </body>
</html>