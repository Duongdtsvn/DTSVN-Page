<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-impressiveNumber wow fadeInUp">
            <div class="container-custom">
                <div class="row">
                    <div class="col-md-8 col-lg-5 col-xl-5 col-xxxl-5">
                        <div class="titlebox">
                            <h2 class="titlebox__title fz-44"> ${contentModel.achievements_s!''}</h2>
                        </div>
                    </div>
                </div>
                <div class="impressiveNumber-list">
                    <div class="row">
                        <#if contentModel.achievements_o.item?? && contentModel.achievements_o.item?has_content>
                            <#list contentModel.achievements_o.item as achievements>
                                <div class="col-md-6 col-xl-3">
                                    <div class="item">
                                        <div class="item__inner">
                                            <div class="item__number">${achievements.number_s!''}</div>
                                            <h4 class="item__title">${achievements.subtitle4_s!''}</h4>
                                        </div>
                                    </div>
                                </div>
                            </#list>
                        </#if>
                    </div>
                </div>
            </div>
        </section>