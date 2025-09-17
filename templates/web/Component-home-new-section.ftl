<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-newUpdate">
    <div class="container-custom">
        <div class="sec-newUpdate__wrap">
            <div class="sec-newUpdate__header wow fadeInUp  effect" style="visibility: visible;">
                <div class="row align-items-center">
                    <div class="col-md-7 col-xl-6">
                        <h2 class="item-title">${contentModel.title_s!''}</h2>
                    </div>
                    <div class="col-md-5 col-xl-6">
                        <div class="item-btn d-none d-md-block">
                            <a href="${contentModel.link_s!''}" class="btn-text">${contentModel.label_s!''}<span></span></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="sec-newUpdate__content wow fadeInUp  effect" style="visibility: visible;">
                <#if latestNews?? && (latestNews?size > 0)>
                    <#list latestNews as news>
                        <div class="item">
                            <div class="postMin">
                                <div class="postMin__inner">
                                    <h3 class="postMin__title">
                                        <a href="${news.url!''}">${news.title_vi!news.title!''}</a>
                                    </h3>
                                    <ul class="postMin__meta">
                                        <#if news.created_date??>
                                            <li>
                                                <#if news.created_date?is_date>
                                                    ${news.created_date?string("dd/MM/yyyy")}
                                                <#else>
                                                    ${news.created_date!''}
                                                </#if>
                                            </li>
                                        </#if>
                                        <#if news.categories?? && (news.categories?size > 0)>
                                            <li>
                                                <a href="?tab=${news.categories?first!''}">${news.categories?first!''}</a>
                                            </li>
                                        </#if>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </#list>
                <#else>
                    <div class="item">
                        <div class="postMin">
                            <div class="postMin__inner">
                                <h3 class="postMin__title"><a href="#">Không có tin tức mới</a></h3>
                                <ul class="postMin__meta">
                                    <li>--/--/----</li>
                                    <li><a href="#">Tin tức</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </#if>
            </div>
            <div class="sec-newUpdate__btn d-md-none">
                <a href="${contentModel.link_s!''}" class="btn-text">${contentModel.label_s!''}<span></span></a>
            </div>
        </div>
    </div>
</section>