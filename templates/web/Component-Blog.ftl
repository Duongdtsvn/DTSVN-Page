<#import "/templates/system/common/crafter.ftl" as crafter />


<section class="section sec-newUpdate">
                <div class="container-custom">
                  <div class="sec-newUpdate__wrap">
                    
                    <div class="sec-newUpdate__header wow fadeInUp">
                      <div class="row align-items-center">
                        <div class="col-md-7 col-xl-6">
                          <h2 class="item-title">Tin tức cập nhật</h2>
                        </div>
                        <div class="col-md-5 col-xl-6">
                          <div class="item-btn d-none d-md-block">
                            <a href="category/tin-tuc" class="btn-text">Xem tất cả <span></span></a>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="sec-newUpdate__content wow fadeInUp">
                    <#if contentModel.blog_all_o.item?? && contentModel.blog_all_o.item?has_content>
                    <#list contentModel.blog_all_o.item as blog_all>
                      <div class="item">
                        <div class="postMin">
                          <div class="postMin__inner">
                            <h3 class="postMin__title"><a href="#">${blog_all.title_s!''}</a></h3>
                            <ul class="postMin__meta">
                              <li>${blog_all.date_s!''}</li>
                              <li><a href="#">
                                Tin tức cập nhật</a></li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      </#list>
                      </#if>
                    </div>
                    <div class="sec-newUpdate__btn d-md-none">
                      <a href="#" class="btn-text">Xem tất cả <span></span></a>
                    </div>
                  </div>
                </div>
              </section>