<#-- Import thư viện Crafter CMS để sử dụng các component và macro -->
<#import "/templates/system/common/crafter.ftl" as crafter />
<#import "/templates/system/common/commonHead.ftl" as common />

<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DTSVN - Tin tức</title>
    <@common.commonHead 
    
  />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="/static-assets/css/header.css">
    <link rel="stylesheet" href="/static-assets/css/main.css">
    <@crafter.head />
  </head>   
  <body>
    <@crafter.body_top />
    <@crafter.renderComponentCollection $field="header_o"/>
    <section class="section sec-pageTitle  style-2 style-doitac">
        <div class="sec-pageTitle__wrap">
            <ul class="sec-pageTitle__breadcrumb">
                <li><a href="/">Trang chủ</a></li>
                <li><span>Tin tức</span></li>
            </ul>
            <div class="sec-pageTitle__content">
                <div class="container-custom">
                    <div class="row">
                        <div class="col-md-8 col-lg-7 col-xl-6">  
                            <h1 class="sec-pageTitle__title fz-52">${contentModel["internal-name"]!''}</h1>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="section sec-blogPage">
        <div class="container-custom">
            <div class="search-form mb-4">
                <form method="GET" action="" class="d-flex align-items-center row g-2">
                    <div class="col-md-2">
                        <select name="tab" class="form-select" style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd; min-width: 140px;">
                            <option value="all" <#if (selectedTab!'all') == 'all'>selected</#if>>Tất cả</option>
                            <#list tabs as cat>
                                <option value="${cat.item_s_s!''}" <#if (selectedTab!'') == (cat.item_s_s!'')>selected</#if>>${cat.title_category_s!''}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <input type="text" name="title" value="${searchParams.title!''}" placeholder="Tìm theo tiêu đề..." class="form-control" style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                    </div>
                    <div class="col-md-2 d-flex">
                        <button type="submit" class="btn btn-primary flex-grow-1">Tìm kiếm</button>
                        <#if searchParams.title?? || searchParams.content?? || (selectedTab != 'all')>
                            <a href="?tab=all" class="btn btn-outline-secondary ms-2">Xóa</a>
                        </#if>
                    </div>
                    <#-- <div class="col-md-2">-->
                        <#-- <select name="sort" class="form-select">-->
                            <#-- <option value="newest" <#if sort == "newest">selected</#if>>Mới nhất đến cũ nhất</option>-->
                            <#-- <option value="oldest" <#if sort == "oldest">selected</#if>>Cũ nhất đến mới nhất</option>-->
                           <#-- <option value="a_to_z" <#if sort == "a_to_z">selected</#if>>A đến Z</option>-->
                           <#-- <option value="z_to_a" <#if sort == "z_to_a">selected</#if>>Z đến A</option>-->
                        <#-- </select>-->
                    <#-- </div>-->
                </form>
            </div>
            <#-- Ẩn thanh tab khi đang tìm kiếm -->
            <#if !(searchParams.title?? && searchParams.title?length > 0) && !(searchParams.content?? && searchParams.content?length > 0)>
                <nav class="nav-cat">
                    <ul>
                        <li>
                            <a href="?tab=all<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>" class="<#if (selectedTab!'') == 'all'>active</#if>">Tất cả tin bài</a>
                        </li>
                        <#if tabs?has_content>
                            <#list tabs as category>
                                <li>
                                    <a href="?tab=${category.item_s_s!''}<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>" class="<#if (selectedTab!'') == (category.item_s_s!'')>active</#if>">${category.title_category_s!''}</a>
                                </li>
                            </#list>
                        </#if>
                    </ul>
                </nav>
            </#if>
            <div class="row">
                <#if newsItems?? && (newsItems?size > 0)>
                    <#list newsItems as news>
                        <div class="col-md-6 col-lg-4">
                            <div class="blog">
                                <div class="blog__inner">
                                    <a class="blog__img" href="${news.url!''}" style="background-image: url('${(news.img_main_s?? && (news.img_main_s?length > 0))?then(news.img_main_s, '/static-assets/images/news/default-news.jpg')}');">
                                        <img src="${(news.img_main_s?? && (news.img_main_s?length > 0))?then(news.img_main_s, '/static-assets/images/news/default-news.jpg')}" alt="${news.title!''}">
                                    </a>
                                    <div class="blog__body">
                                        <h3 class="blog__title">
                                            <a href="${news.url!''}">${news.title!''}</a>
                                        </h3>
                                        <#if news.highlight?? && (news.highlight!'') != ''>
                                            <div class="blog__excerpt">
                                                <p>${news.highlight!''}</p>
                                            </div>
                                        </#if>
                                        <ul class="postMin__meta">
                                            <#if news.created_date??>
                                                <li>
                                                    <#if news.created_date?is_date>
                                                        ${news.created_date?string("dd/MM/yyyy HH:mm")}
                                                    <#else>
                                                        ${news.created_date!''}
                                                    </#if>
                                                </li>
                                            </#if>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </#list>
                <#else>
                    <div class="col-12">
                        <div class="text-center py-5">
                            <h3>Không tìm thấy tin tức nào</h3>
                            <p>
                                Không tìm thấy tin tức nào phù hợp với tiêu chí tìm kiếm.
                                <br>Bạn có thể thử với từ khóa khác hoặc kiểm tra lại chính tả.
                            </p>
                        </div>
                    </div>
                </#if>
            </div>
            <#if totalPages?? && (totalPages > 1)>
                <div class="pagination">
                    <nav class="navigation pagination" aria-label="Phân trang bài viết">
                        
                        <div class="nav-links">
                            <#if hasPrevPage?? && hasPrevPage>
                                <a class="prev page-numbers" href="?tab=${selectedTab!''}&page=${(currentPage!1) - 1}<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>">← Previous</a>
                            </#if>
                            <#if pageNumbers?? && (pageNumbers?size > 0)>
                                <#if pageNumbers?first?number gt 1>
                                    <#if pageNumbers?first?number gt 2>
                                        <a class="page-numbers" href="?tab=${selectedTab!''}&page=1<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>">1</a>
                                        <span class="page-numbers dots">…</span>
                                    <#else>
                                        <a class="page-numbers" href="?tab=${selectedTab!''}&page=1<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>">1</a>
                                    </#if>
                                </#if>
                                <#list pageNumbers as pageNum>
                                    <#if (pageNum?number) == (currentPage!1)?number>
                                        <span aria-current="page" class="page-numbers current">${pageNum}</span>
                                    <#else>
                                        <a class="page-numbers" href="?tab=${selectedTab!''}&page=${pageNum}<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>">${pageNum}</a>
                                    </#if>
                                </#list>
                                <#if pageNumbers?last?number lt (totalPages!1)?number>
                                    <#if pageNumbers?last?number lt (totalPages!1)?number - 1>
                                        <span class="page-numbers dots">…</span>
                                        <a class="page-numbers" href="?tab=${selectedTab!''}&page=${totalPages!1}<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>">${totalPages!1}</a>
                                    <#else>
                                        <a class="page-numbers" href="?tab=${selectedTab!''}&page=${totalPages!1}<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>">${totalPages!1}</a>
                                    </#if>
                                </#if>
                            </#if>
                            <#if hasNextPage?? && hasNextPage>
                                <a class="next page-numbers" href="?tab=${selectedTab!''}&page=${(currentPage!1) + 1}<#if searchParams.title??>&title=${searchParams.title}</#if><#if searchParams.content??>&content=${searchParams.content}</#if><#if sort??>&sort=${sort}</#if>">Next →</a>
                            </#if>
                        </div>
                    </nav>
                </div>
            </#if>
            <#if totalItems?? && (totalItems > 0)>
                <div class="pagination-info text-center mt-3">
                    <#assign fromItem = (((currentPage!1) - 1) * (itemsPerPage!12)) + 1 />
                    <#assign toItem = ((currentPage!1) * (itemsPerPage!12) < (totalItems!0))?then((currentPage!1) * (itemsPerPage!12), (totalItems!0)) />
                    <p>
                        Hiển thị ${fromItem} - ${toItem} trong tổng số ${totalItems!0} tin tức
                    </p>
                </div>
            </#if>
        </div>
    </section>
    <@crafter.renderComponentCollection $field="footer_o"/>
    <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>
    <@crafter.body_bottom />
  </body>
</html>