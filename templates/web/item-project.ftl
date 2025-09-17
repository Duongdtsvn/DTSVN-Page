<#import "/templates/system/common/crafter.ftl" as crafter />
<#import "/templates/system/common/commonHead.ftl" as common />
<!doctype html>
<html lang="en">
<head>
  <#-- Thiết lập meta charset và viewport cho responsive -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<@common.commonHead 
  description="${contentModel['title_vi_s']!''}" 
  title="${contentModel['title_vi_s']!''}" 
  image="${(contentModel.img_main_s?? && contentModel.img_main_s?length > 0)?then(contentModel.img_main_s, '/static-assets/images/logo/dtsvn_logomark_color.png')}" 
  url="${contentModel.url!request.url!''}" />
  <#-- Load jQuery library cho JavaScript -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <#-- Import các file CSS cho styling -->
  <link rel="stylesheet" href="/static-assets/css/header.css">
  <link rel="stylesheet" href="/static-assets/css/main.css?site=${siteContext.siteName}"/>
  <link rel="stylesheet" href="/static-assets/css/language-switcher.css"/>

  <#-- Header: chỉ hiển thị 1 header theo ngôn ngữ -->
  <div data-lang="vi">
    <@crafter.renderComponentCollection $field="header_VN_o"/>
  </div>
  <div data-lang="en" style="display:none;">
    <@crafter.renderComponentCollection $field="header_EN_o"/>
  </div>
  
  <#-- Render head component từ Crafter CMS -->
  <@crafter.head />
</head>
<body>
  <@crafter.body_top />
  <main class="page-content">
    <section class="section sec-pageTitle style-blogDetail style-2">
      <div class="sec-pageTitle__wrap">
        <ul class="sec-pageTitle__breadcrumb" data-lang="vi">
                <li><a href="/"> Trang chủ </a></li>
                    <li><span>Dự án</span></li>
            </ul>
        <ul class="sec-pageTitle__breadcrumb" data-lang="en" style="display:none;">
                <li><a href="/en"> Home </a></li>
                <li><span>Project</span></li>
            </ul>
        <div class="sec-pageTitle__content">
          <div class="container-custom">
            <div class="row align-items-end">
              <div class="col-md-9 col-xl-6">
                <h1 class="sec-pageTitle__title fz-52" data-lang="vi">${contentModel.title_vi_s!''}</h1>
                <h1 class="sec-pageTitle__title fz-52" data-lang="en" style="display:none;">${contentModel.title_en_s!''}</h1>
              </div>
              <div class="col-md-3 col-xl-6">
                <div class="sec-pageTitle__share">
                  <a href="#" class="btn-share" data-lang="vi">Chia sẻ
                    <span>
                      <svg width="13" height="15" viewBox="0 0 13 15" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M10.6703 5.00004C9.99771 5.00004 9.3913 4.70437 8.96803 4.23304L4.77962 6.68282C4.84477 6.90188 4.87982 7.13429 4.87982 7.37496C4.87982 7.61555 4.8448 7.84788 4.7797 8.06687L8.96769 10.5164C9.39098 10.0448 9.99753 9.74902 10.6703 9.74902C11.947 9.74902 12.9852 10.8143 12.9852 12.1241C12.9852 13.4338 11.947 14.4991 10.6703 14.4991C9.39363 14.4991 8.35547 13.4338 8.35547 12.1241C8.35547 11.931 8.37802 11.7433 8.42057 11.5635L4.17483 9.08017C3.75793 9.49457 3.18997 9.74993 2.56486 9.74993C1.28827 9.74993 0.25 8.68481 0.25 7.37496C0.25 6.06512 1.28827 5 2.56486 5C3.1899 5 3.75779 5.25529 4.17468 5.66961L8.42069 3.1861C8.37807 3.00613 8.35547 2.81821 8.35547 2.62496C8.35547 1.31523 9.39363 0.25 10.6703 0.25C11.947 0.25 12.9852 1.31523 12.9852 2.62496C12.9852 3.93481 11.947 5.00004 10.6703 5.00004Z" fill="#2B6BB2"></path>
                      </svg>
                    </span>
                  </a>
                  <a href="#" class="btn-share" data-lang="en" style="display:none;">Share
                    <span>
                      <svg width="13" height="15" viewBox="0 0 13 15" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M10.6703 5.00004C9.99771 5.00004 9.3913 4.70437 8.96803 4.23304L4.77962 6.68282C4.84477 6.90188 4.87982 7.13429 4.87982 7.37496C4.87982 7.61555 4.8448 7.84788 4.7797 8.06687L8.96769 10.5164C9.39098 10.0448 9.99753 9.74902 10.6703 9.74902C11.947 9.74902 12.9852 10.8143 12.9852 12.1241C12.9852 13.4338 11.947 14.4991 10.6703 14.4991C9.39363 14.4991 8.35547 13.4338 8.35547 12.1241C8.35547 11.931 8.37802 11.7433 8.42057 11.5635L4.17483 9.08017C3.75793 9.49457 3.18997 9.74993 2.56486 9.74993C1.28827 9.74993 0.25 8.68481 0.25 7.37496C0.25 6.06512 1.28827 5 2.56486 5C3.1899 5 3.75779 5.25529 4.17468 5.66961L8.42069 3.1861C8.37807 3.00613 8.35547 2.81821 8.35547 2.62496C8.35547 1.31523 9.39363 0.25 10.6703 0.25C11.947 0.25 12.9852 1.31523 12.9852 2.62496C12.9852 3.93481 11.947 5.00004 10.6703 5.00004Z" fill="#2B6BB2"></path>
                      </svg>
                    </span>
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="section sec-blogDetail">
      <div class="container-custom">
        <div class="row">
          <div class="col-xxxl-10 offset-xxxl-1">
            <div class="sec-blogDetail__content stickyJs">
              <div class="row">
                <div class="col-xl-8 col-xxxl-7">
                  <div class="entry-text" data-lang="vi">
                    ${contentModel.content_vi_html!''}
                  </div>
                  <div class="entry-text" data-lang="en" style="display:none;">
                    ${contentModel.content_en_html!''}
                  </div>

                  <div class="entry-share">
                    <span data-lang="vi">Chia sẻ: <a> </a></span>
                    <span data-lang="en" style="display:none;">Share: <a> </a></span>
                    <a href="#"><img src="assets/img/icon-facebook.svg" alt=""></a>
                    <a href="#"><img src="assets/img/icon-pinterest.svg" alt=""></a>
                    <a href="#"><img src="assets/img/icon-linkedin.svg" alt=""></a>
                    <a href="#"><img src="assets/img/icon-skype.svg" alt=""></a>
                    <a href="#"><img src="assets/img/icon-discord.svg" alt=""></a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="row" data-lang="vi">
          <@crafter.renderComponentCollection $field="contact_VN_o"/>
        </div>
        <div class="row" data-lang="en" style="display:none;">
          <@crafter.renderComponentCollection $field="contact_EN_o"/>
        </div>
      </div>
    </section>
  </main>
  
  <div data-lang="vi">
    <@crafter.renderComponentCollection $field="footer_VN_o"/>
  </div>
  <div data-lang="en" style="display:none;">
    <@crafter.renderComponentCollection $field="footer_EN_o"/>
  </div>

  <script src="/static-assets/js/language-switcher.js"></script>
  <@crafter.body_bottom />
</body>
</html>