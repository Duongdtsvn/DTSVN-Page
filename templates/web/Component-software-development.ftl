<#import "/templates/system/common/crafter.ftl" as crafter />


<section class="section sec-dvptpm">
                <div class="container-custom">
                    <div class="row">
                        <div class="col-xl-7 col-xxxl-5">
                            <div class="titlebox">
                                <span class="titlebox__subtitle">${contentModel.title_s!''}</span>
                                <h2 class="titlebox__title">${contentModel.subtitle_s!''}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xl-10 offset-xl-1 col-xxxl-9 offset-xxxl-2">
                            <div class="sec-dvptpm__list">
                              <#if contentModel.software_developer_o.item?? && contentModel.software_developer_o.item?has_content>
                              <#list contentModel.software_developer_o.item as software_developer>
                                <div class="item">
                                    <div class="row">
                                        <div class="col-md-5 col-xxxl-5">
                                            <h3 class="item__title">${software_developer.title1_s!''}</h3>
                                        </div>
                                        <div class="col-md-7 col-xxxl-5 offset-xxxl-2">
                                            <div class="item__body">
                                                <div class="item__entry">
                                                    <p>${software_developer.describe_s!''}</p>
                                                </div>
                                                <div class="item__btn">
                                                    <a href="https://dtsvn.net/service" class="btn-text">${software_developer.learn_more_s!''}<span></span></a>
                                                </div>
                                            </div>
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