<#-- Import thư viện Crafter CMS để sử dụng các component và macro -->
<#import "/templates/system/common/crafter.ftl" as crafter />
<#import "/templates/system/common/commonHead.ftl" as common />

<!doctype html>
<html lang="en">
<head>
  <#-- Thiết lập meta charset và viewport cho responsive -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>DTSVN - Contact</title>
<@common.commonHead />
  <#-- Load jQuery library cho JavaScript -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <#-- Import các file CSS cho styling -->
  <link rel="stylesheet" href="/static-assets/css/header.css">
  <link rel="stylesheet" href="/static-assets/css/main.css">

  <#-- Render head component từ Crafter CMS -->
  <@crafter.head />
</head>
<body>
  <#-- Render body top component từ Crafter CMS -->
  <@crafter.body_top />

  <#-- Render header component collection -->
  <@crafter.renderComponentCollection $field="header_o"/>

  <main class="page-content">
    <section class="section sec-pageTitle style-lienhe">
      <div class="sec-pageTitle__wrap">
        <ul class="sec-pageTitle__breadcrumb">
          <li><a href="/en">Home</a></li>
          <li><span>Contact</span></li>
        </ul>
        <div class="sec-pageTitle__content">
          <div class="container-custom">
            <div class="row">
              <div class="col-md-8 col-lg-7 col-xl-6">
                <h1 class="sec-pageTitle__title fz-52">${contentModel["navLabel"]!''}</h1>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="section sec-contactPage">
      <div class="container-custom">
        <div class="row">
          <div class="col-xl-6 col-xxxl-6 offset-xxxl-1 order-xl-2">
            <div class="sec-contactPage__content">
              <h3 class="sec-contactPage__title">${contentModel.title_main_s!''}</h3>
              <div class="wpcf7 js" id="wpcf7-f6-o1" lang="en" dir="ltr">
                <div class="screen-reader-response">
                  <p role="status" aria-live="polite" aria-atomic="true"></p>
                  <ul></ul>
                </div>
                <form id="contactForm" action="/api/1/services/contactUs" method="post" class="wpcf7-form init" aria-label="Form liên hệ" novalidate="novalidate" data-status="init">
                  <#if contentModel.list_input_o.item?has_content>
                    <div class="row g-3">
                      <#list contentModel.list_input_o.item as form>
                        <#if form.fied_name_s?? && form.fied_name_s == "your-message">
                          <div class="col-12">
                            <div class="form-item">
                              <span class="wpcf7-form-control-wrap" data-name="${form.fied_name_s!''}">
                                <textarea
                                  cols="40"
                                  rows="10"
                                  maxlength="2000"
                                  class="wpcf7-form-control wpcf7-textarea"
                                  aria-invalid="false"
                                  placeholder="${form.label_name_s!''}*"
                                  name="${form.fied_name_s!''}"></textarea>
                              </span>
                            </div>
                          </div>
                        <#elseif form.fied_name_s?? && form.fied_name_s == "your-email">
                          <div class="col-md-6">
                            <div class="form-item">
                              <span class="wpcf7-form-control-wrap" data-name="${form.fied_name_s!''}">
                                <input
                                  size="40"
                                  maxlength="400"
                                  class="wpcf7-form-control wpcf7-email wpcf7-validates-as-required wpcf7-text wpcf7-validates-as-email"
                                  autocomplete="${form.autocomplete_s!''}"
                                  aria-required="true"
                                  aria-invalid="false"
                                  placeholder="${form.label_name_s!''}*"
                                  value=""
                                  type="email"
                                  name="${form.fied_name_s!''}">
                              </span>
                            </div>
                          </div>
                        <#else>
                          <div class="col-md-6">
                            <div class="form-item">
                              <span class="wpcf7-form-control-wrap" data-name="${form.fied_name_s!''}">
                                <input
                                  size="40"
                                  maxlength="400"
                                  class="wpcf7-form-control wpcf7-text wpcf7-validates-as-required"
                                  autocomplete="${form.autocomplete_s!''}"
                                  aria-required="true"
                                  aria-invalid="false"
                                  placeholder="${form.label_name_s!''}*"
                                  value=""
                                  type="text"
                                  name="${form.fied_name_s!''}">
                              </span>
                            </div>
                          </div>
                        </#if>
                      </#list>
                      <div class="col-12 text-center">
  <div class="form-btn">
    <a href="/404" class="wpcf7-form-control wpcf7-submit has-spinner">
      ${contentModel.label_button_s!''}
    </a>
  </div>
</div>
                    </div>
                  </#if>
                  <div class="wpcf7-response-output" aria-hidden="true"></div>
                </form>
              </div>
            </div>
          </div>
          <div class="col-xl-6 col-xxxl-5 order-xl-1">
            <div class="sec-contactPage__info">
              <div class="row">
                <div class="col-12 order-md-2">
                  <div class="row">
                    <div class="col-md-5 col-xl-5">
                      <h3 class="sec-contactPage__title">${contentModel.title_main_1_s!''}</h3>
                    </div>
                    <div class="col-md-7 col-xl-7">
                      <ul class="item-info">
                        <li>
                          <span>Address</span>
                          <p>${contentModel.address_s!''}</p>
                        </li>
                        <li>
                          <span>Phone</span>
                          <p>
                            <a href="tel:${contentModel.phone_s!''}" style="text-decoration: none;">
                              ${contentModel.phone_s!''}
                            </a>
                          </p>
                        </li>
                        <li>
                          <span>Email</span>
                          <p>
                            <a href="mailto:${contentModel.email_s!''}" style="text-decoration: none;">
                              ${contentModel.email_s!''}
                            </a>
                          </p>
                        </li>
                        <li>
                          <span>Website</span>
                          <p>
                            <a href="${contentModel.website_s!''}" style="text-decoration: none;">
                              ${contentModel.website_s!''}
                            </a>
                          </p>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
                <div class="col-12 order-md-1">
                  <div class="mapbox">
                    <iframe
                      src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d5824.196764890728!2d105.81940001671367!3d21.011408815709466!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x5d7af9346f5461b8!2sTH%20OFFICE%20TOWER%2015%20-%20116%20Trung%20Li%E1%BB%87t!5e0!3m2!1svi!2s!4v1631588923582!5m2!1svi!2s"
                      width="600"
                      height="450"
                      style="border:0;"
                      allowfullscreen=""
                      loading="lazy"></iframe>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>

  <@crafter.renderComponentCollection $field="footer_o"/>
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>
  <@crafter.body_bottom />
</body>
</html>