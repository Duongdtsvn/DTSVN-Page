<#import "/templates/system/common/crafter.ftl" as crafter />


<section class="section sec-productOrien pb-0">
  <div class="container-custom">
      <div class="row">
          <div class="col-xl-5">
              <div class="titlebox">
                  <h2 class="titlebox__title fz-32">${contentModel.title_s!''}</h2>
              </div>
          </div>
      </div>
      <div class="sec-productOrien__header">
          <div class="numberBox-list">
              <div class="row">
                <#if contentModel.ba_results_o.item?? && contentModel.ba_results_o.item?has_content>
                <#list contentModel.ba_results_o.item as ba_results>
                  <div class="col-md-6 col-xl-4">
                      <div class="numberBox">
                          <div class="numberBox__inner">
                              <h3 class="numberBox__title">${ba_results.title1_s!''}</h3>
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