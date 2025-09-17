<#-- Import thư viện Crafter CMS để sử dụng các component và macro -->
<#import "/templates/system/common/crafter.ftl" as crafter />
<#import "/templates/system/common/commonHead.ftl" as common />

<!doctype html>
<html lang="en">
  <head>
    <#-- Thiết lập meta charset và viewport cho responsive -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DTSVN - Projects</title>
    <@common.commonHead />
    <#-- Load jQuery library cho JavaScript -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <#-- Import các file CSS cho styling -->
    <link rel="stylesheet" href="/static-assets/css/header.css">
    <link rel="stylesheet" href="/static-assets/css/main.css">
    
    <#-- Render head component từ Crafter CMS -->
    <@crafter.head />
  </head>
  <body>
    <#-- Render body top component từ Crafter CMS -->
    <@crafter.body_top />
    
    <#-- Render header component collection -->
    <@crafter.renderComponentCollection $field="header_o"/>
    
   <main class="page-content">
        <!-- Page Title Section -->
        <section class="section sec-pageTitle style-productF style-2">
            <div class="sec-pageTitle__wrap">
                <ul class="sec-pageTitle__breadcrumb">
                    <li><a href="/en">Home</a></li>
                    <li><span>Featured Projects</span></li>
                </ul>
                <div class="sec-pageTitle__content">
                    <div class="container-custom">
                        <div class="row">
                            <div class="col-md-8 col-lg-7 col-xl-6">
                                <h1 class="sec-pageTitle__title fz-52">${contentModel.title_main_s!''}</h1>
                                <p class="sec-pageTitle__text">${contentModel.text_main_t!''}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Projects Section -->
        <section class="section sec-projectFeature">
            <div class="container-custom">
                <div class="projectFeature-list">
                    <#-- Kiểm tra có dự án để hiển thị không -->
                    <#if projectItems?? && (projectItems?size > 0)>
                        <#-- Lặp qua từng dự án -->
                        <#list projectItems as project>
                            <div class="projectFeature">
                                <div class="row">
                                    <div class="col-md-5 col-xxxl-4">
                                        <a href="${project.url_en!''}" class="projectFeature__img" style="background-image: url('${(project.img_main_s?? && (project.img_main_s?length > 0))?then(project.img_main_s, '/static-assets/images/projects/default-project.jpg')}');">
                                        </a>
                                    </div>
                                    <div class="col-md-7 col-xxxl-6">
                                        <div class="projectFeature__body">
                                            <h3 class="projectFeature__title">
                                                <a href="${project.url_en!''}">${project.title_en!''}</a>
                                            </h3>
                                            <div class="projectFeature__text">
                                                <#if project.info_main_en?? && (project.info_main_en!'') != ''>
                                                    <p>${project.info_main_en!''}</p>
                                                <#else>
                                                    <p>Project information is being updated...</p>
                                                </#if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </#list>
                    <#else>
                        <#-- Hiển thị thông báo khi không có dự án -->
                        <div class="col-12">
                            <div class="text-center py-5">
                                <h3>No projects found</h3>
                                <p>Please try again later.</p>
                            </div>
                        </div>
                    </#if>

                    <#-- Phân trang - chỉ hiển thị khi có nhiều hơn 1 trang -->
                    <#if totalPages?? && (totalPages > 1)>
                        <div class="pagination">
                            <nav class="navigation pagination" aria-label="Project pagination">
                                
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
                            <#assign fromItem = (((currentPage!1) - 1) * (itemsPerPage!12)) + 1 />
                            <#assign toItem = ((currentPage!1) * (itemsPerPage!12) < (totalItems!0))?then((currentPage!1) * (itemsPerPage!12), (totalItems!0)) />
                            <p>Showing ${fromItem} - ${toItem} of ${totalItems!0} projects</p>
                        </div>
                    </#if>
                </div>
            </div>
        </section>
    </main>
    <@crafter.renderComponentCollection $field="footer_o"/>
    <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>
    <@crafter.body_bottom />
  </body>
</html>