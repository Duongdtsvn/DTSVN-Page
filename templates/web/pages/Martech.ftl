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

<section class="section sec-productOrien">
    <div class="container-custom">
        <div class="row">
            <div class="col-xl-5">
                <div class="titlebox">
                    <!-- Tiêu đề -->
                    <h2 class="titlebox__title fz-32">
                        ${contentModel.title_s!''}
                    </h2>
                    <!-- Mô tả -->
                    <p>${contentModel.text_s!''}</p>
                </div>
            </div>
        </div>

        <div class="sec-productOrien__header">
            <div class="numberBox-list">
                <div class="row">
                    <#if contentModel.orientation_o.item?? && contentModel.orientation_o.item?has_content>
                        <#list contentModel.orientation_o.item as item>
                            <div class="col-md-6 col-xl-5">
                                <div class="numberBox">
                                    <div class="numberBox__inner">
                                        <!-- Số thứ tự -->
                                        <span class="numberBox__number">
                                            ${item.number_s!''}
                                        </span>
                                        <!-- Nội dung -->
                                        <h3 class="numberBox__title">
                                            ${item.title_s!''}
                                        </h3>
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
<section class="section sec-vision">
    
        <div class="bg" style="background-image: url(${contentModel.background_s!''});"></div>
    
    <div class="container-custom">
        <div class="row">
            <div class="col-xl-7 col-xxl-6 col-xxxl-5">
                
                    <h2 class="item-quote">${contentModel.title1_s!''}</h2>
               
                
                    <p style="color:white">${contentModel.description1_s!''}</p>
                
            </div>
        </div>
        <div class="row">
            <div class="col-xl-8 offset-xl-4 col-xxl-6 offset-xxl-6">
                <div class="sec-vision__list">
                    <div class="row">
                        <#if contentModel.list_o?? && contentModel.list_o.item?? && contentModel.list_o.item?has_content>
  <#list contentModel.list_o.item as list>
                                <div class="col-lg-7">
                                    <div class="item">
                                        <label class="item__label">
                                            <input type="checkbox">
                                            
                                                <h3 class="item__title">${list.title_s!''}</h3>
                                           
                                           
                                                <div class="item__content">
                                                    <p class="item__text">${list.text_s!''}</p>
                                                </div>
                                            
                                        </label>
                                    </div>
                                </div>
                            </#list>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="section pb-0">
  <div class="container-custom">
    <div class="row">
      <div class="col-xl-12">
        <img src="${contentModel.image1_s!''}" alt="">
      </div>
    </div>
  </div>
</section>
        <@crafter.renderComponentCollection $field="custom_o" />
        <@crafter.renderComponentCollection $field="partner_o" />
        <@crafter.renderComponentCollection $field="footer_o" />
    </main>
    
<script src="/static-assets/js/function.js"></script>
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>


    <@crafter.body_bottom />
</body>

</html>