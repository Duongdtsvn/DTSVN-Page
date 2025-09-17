<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-strength pb-0">
  <div class="container-custom">
      <div class="sec-strength__wrap">
         
          <div class="sec-strength__list owl-carousel">
          <div class="titlebox item">
              <h2 class="titlebox__title fz-44 ">${contentModel.who_studies_s!''}</h2>
                </div>
              <#if contentModel.who_studies_o.item?? && contentModel.who_studies_o.item?has_content>
              <#list contentModel.who_studies_o.item as who_studies>
              <div class="item">
                  <div class="featurebox" style="border: 1px solid #E3E5EA ">
                      <div class="featurebox__inner">
                          <span class="featurebox__icon">
                            <@crafter.img $field="icon_s" src=(who_studies.icon_s!"") alt="" />
                          </span>
                          <div class="featurebox__body">
                              <div class="translate" data-translate=".featurebox__text" style="--y: 90px">
                                  <span class="featurebox__number">${who_studies.number_s!''}</span>
                                  <h3 class="featurebox__title">${who_studies.title_s!''}</h3>
                                  <p class="featurebox__text" style="visibility: visible;">${who_studies.subtitle_s!''}</p>
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
</section>