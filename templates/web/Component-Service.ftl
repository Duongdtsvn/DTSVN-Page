<#import "/templates/system/common/crafter.ftl" as crafter />


<section class="section sec-pageTitle style-2 style-blogDetail">
    <div class="sec-pageTitle__wrap">
        <div class="sec-pageTitle__content">
            <div class="container-custom">
                <div class="row">
                    <div class="col-md-8 col-lg-7 col-xl-6">
                        <h1 class="sec-pageTitle__title fz-52">
                            ${contentModel.title_s!''}
                        </h1>
                        <p class="sec-pageTitle__text">${contentModel.text_s!''}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section sec-productBox">
    <div class="container-custom">
        <div class="productbox-list">
            <#if contentModel.service_o.item?? && contentModel.service_o.item?has_content>
                <#list contentModel.service_o.item as service>
                    <div class="item service">
                        <div class="productbox hover">
                            <div class="productbox__inner">
                                <div class="group">
                                    <!-- Hiển thị thẻ (tags) -->
                                    <span class="productbox__subtitle">
                                        ${service.key_main_s!''}
                                    </span>
                                    <h3 class="productbox__title">
                                        <a href="${service.link_s!''}">${service.title_s!''}</a>
                                    </h3>
                                </div>
                                <div class="productbox__btn">
                                    <a href="${service.link_s!''}" class="btn-text">
                                        ${service.text_s!''} <span></span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            </#if>
        </div>
</section>