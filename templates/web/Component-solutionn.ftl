<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-partnerships">
  <div class="container-custom">
    <div class="partnershipsBox wow fadeInUp">
      <!-- Header -->
      <div class="partnershipsBox__header">
        <div class="row">
          <div class="col-xl-6 order-xl-2">
            <div class="item-img" style="background-image: url(${contentModel.image_s!''});"></div>
          </div>
          <div class="col-xl-6 order-xl-1">
            <div class="item-content">
              <div class="group">
                <h2 class="item-title fz-40">${contentModel.title_s!''}</h2>
              </div>
              <div class="item-btn">
                <a href="partners-customer.html" class="btn-text btn-light">${contentModel.path_s!''}<span></span></a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- List -->
      <div class="partnershipsBox__list">
        <div class="row">
          <!-- Item 1 -->
          <#if contentModel.solutionn_o.item?? && contentModel.solutionn_o.item?has_content>
            <#list contentModel.solutionn_o.item as solutionn>
              <div class="col-md-6 col-xl-3">
                <div class="item">
                  <a href="#">
                    <div class="item__inner">
                      <div class="fix">
                        <span class="item__number"></span>
                        <div class="translate" style="--y: undefinedpx;">
                          <h3 class="item__title">${solutionn.title_s!''}</h3>
                        </div>
                      </div>
                    </div>
                  </a>
                </div>
              </div>
            </#list>
          </#if>
        </div>
      </div>
    </div>
  </div>
</section>