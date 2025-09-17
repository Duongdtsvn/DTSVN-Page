<#import "/templates/system/common/crafter.ftl" as crafter />
<#import "/templates/system/common/commonHead.ftl" as common />

<!doctype html>
<html lang="en" class="demo">

<head>
   <@common.commonHead />
    <@crafter.head />
</head>

<body>
    <@crafter.body_top />

    <main class="page-content">
        <@crafter.renderComponentCollection $field="header_o" />
        <@crafter.renderComponentCollection $field="banner_o" />
        <#-- Customer Relationships Section -->
<#-- Customer Relationships Section -->
<section class="section sec-partnerships style-2">
    <div class="container-custom">
        <div class="partnershipsBox">
            <div class="partnershipsBox__header">
                <div class="row">
                    <div class="col-xl-6 order-xl-1">
                        <div class="item-content">
                            <div class="group">
                                <div class="titleMin">
                                    <h3 class="titleMin__title">${contentModel.customer_section_subtitle_s!''}</h3>
                                </div>
                                <h2 class="item-title fz-40">${contentModel.customer_section_title_s!''}</h2>
                            </div>
                            <div class="item-btn">
                                <a href="${contentModel.customer_section_link_s!''}" class="btn-text btn-light">${contentModel.client_partner_s!''}<span></span></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-6 order-xl-2">
                        <div class="item-img" style="background-image: url(${contentModel.customer_section_image_s!''});"></div>
                    </div>
                </div>
            </div>
            <div class="partnershipsBox__list">
                <div class="row">
                    <#if contentModel.customer_partnerships_o.item?? && contentModel.customer_partnerships_o.item?has_content>
                        <#list contentModel.customer_partnerships_o.item as partnership>
                            <div class="col-md-6 col-xl-3">
                                <div class="item">
                                    <div class="item__inner">
                                        <div class="fix">
                                            <span class="item__number">${partnership.number_s!''}</span>
                                            <div class="translate" style="--y: 100px">
                                                <h3 class="item__title">${partnership.title_s!''}</h3>
                                                <p class="item__text">${partnership.description_s!''}</p>
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

<#-- Strategic Partnerships Section -->
<section class="section sec-partnerships style-2">
    <div class="container-custom">
        <div class="partnershipsBox">
            <div class="partnershipsBox__header">
                <div class="row">
                    <div class="col-xl-6 order-xl-1">
                        <div class="item-content">
                            <div class="group">
                                <div class="titleMin">
                                    <h3 class="titleMin__title">${contentModel.strategic_section_subtitle_s!''}</h3>
                                </div>
                                <h2 class="item-title fz-40">${contentModel.strategic_section_title_s!''}</h2>
                            </div>
                            <div class="item-btn">
                                <a href="${contentModel.strategic_section_link_s!''}" class="btn-text btn-light">${contentModel.client_partner_s!''}<span></span></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-6 order-xl-2">
                        <div class="item-img" style="background-image: url(${contentModel.strategic_section_image_s!''});"></div>
                    </div>
                </div>
            </div>
            <div class="partnershipsBox__list">
                <div class="row">
                    <#if contentModel.strategic_partnerships_o.item?? && contentModel.strategic_partnerships_o.item?has_content>
                        <#list contentModel.strategic_partnerships_o.item as partnership>
                            <div class="col-md-6 col-xl-3">
                                <div class="item">
                                    <div class="item__inner">
                                        <div class="fix">
                                            <span class="item__number">${partnership.number_s!''}</span>
                                            <div class="translate" style="--y: 100px">
                                                <h3 class="item__title">${partnership.title_s!''}</h3>
                                                <p class="item__text">${partnership.description_s!''}</p>
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
<@crafter.renderComponentCollection $field="partner_o" />
        <@crafter.renderComponentCollection $field="client_o" />
  <@crafter.renderComponentCollection $field="achievements_o" />
        <@crafter.renderComponentCollection $field="footer_o" />
    </main>
    <script>
  window.addEventListener("load", function () {
    const translates = document.querySelectorAll(".partnershipsBox__list .translate");
    const first = translates[0];
    if (first) {
      const height = first.offsetHeight;
      translates.forEach(el => {
        el.style.setProperty('--y', `${height}px`);
      });
    }
  });
</script>

<script src="/static-assets/js/function.js"></script>
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>

    <@crafter.body_bottom />
</body>

</html>