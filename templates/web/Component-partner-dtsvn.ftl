<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-clientList ">
  <div class="container-custom">
    <div class="row">
      <div class="col-md-8 col-lg-6 col-xl-6">
        <div class="titlebox">
          <h2 class="titlebox__title fz-44">${contentModel.title_s!""}</h2>
        </div>
      </div>
    </div>
    <div class="clientList">
      <div class="row">
        <#if contentModel.partner_dtsvn_o.item?? && contentModel.partner_dtsvn_o.item?has_content>
          <#list contentModel.partner_dtsvn_o.item as partner_dtsvn>
            <div class="col-4 col-md-3 col-xl-2">
              <a class="clientbox" href="https://clevertap.com/">
                <div class="clientbox__inner">
                  <@crafter.img $field="image_partner_s" src=(partner_dtsvn.image_partner_s!"") alt="" />
                </div>
              </a>
            </div>
          </#list>
        </#if>
      </div>
    </div>
  </div>
</section>