<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-productFeatured">
            <div class="container-custom">
                <div class="row">
                    <div class="col-md-8 col-xl-5">
                        <div class="titlebox wow fadeInUp">
                            <h2 class="titlebox__title fz-52">${contentModel.title2_s!''}</h2>
                            <p class="titlebox__text fz-18">${contentModel.subtitle2_s!''}</p>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <#if contentModel.products_o.item?? && contentModel.products_o.item?has_content>
                        <#list contentModel.products_o.item as products>
                            <div class="col-md-6 col-xl-4">
                                <div class="productFeatured wow fadeInUp">
                                    <div class="productFeatured__inner">
                                        <div class="fix">
                                            <span class="productFeatured__subtitle">${products.slogan_s!''}</span>
                                            <h3 class="productFeatured__title"><a
                                                    href="${products.link_s!''}">${products.product_name_s!''}</a></h3>
                                            <div class="productFeatured__btn">
                                                <a href="${products.link_s!''}" class="btn-text">Learn more
                                                    <span></span></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </#list>
                    </#if>
                </div>
            </div>
        </section>