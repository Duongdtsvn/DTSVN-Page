<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-productOrien">
                <div class="container-custom">
                    <div class="row">
                        <div class="col-xl-5">
                            <div class="titlebox">
                                <h2 class="titlebox__title fz-32">${contentModel.orientation_s!''}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="sec-productOrien__header">
                        <div class="numberBox-list">
                            <div class="row">
                              <#if contentModel.orientation_o.item?? && contentModel.orientation_o.item?has_content>
                              <#list contentModel.orientation_o.item as orientation>
                                <div class="col-md-6 col-xl-4">
                                    <div class="numberBox">
                                        <div class="numberBox__inner">
                                            <span class="numberBox__number">${orientation.number_s!''}</span>
                                            <h3 class="numberBox__title">${orientation.text_s!''}</h3>
                                        </div>
                                    </div>
                                </div>
                                </#list>
                                </#if>
                            </div>
                        </div>
                    </div>
                </div>
                </section>
            