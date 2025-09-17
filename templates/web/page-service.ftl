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
  <@crafter.renderComponentCollection $field="header_o" />
  <section class="section sec-pageTitle style-blogDetail style-2">
      <div class="sec-pageTitle__wrap">
        <ul class="sec-pageTitle__breadcrumb" data-lang="vi">
                <li><a href="/">${contentModel.home_s!''}</a></li>
                <li><span>${contentModel.page_s!''}</span></li>
        </ul>
        <div class="sec-pageTitle__content">
          <div class="container-custom">
            <div class="row align-items-end">
              <div class="col-md-9 col-xl-6">
                <h1 class="sec-pageTitle__title fz-52" data-lang="vi">${contentModel.title_s!''}</h1>
              </div>
              <div class="col-md-3 col-xl-6">
                <div class="sec-pageTitle__share">
                  <a href="#" class="btn-share" data-lang="vi">${contentModel.share_s!''}
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
                    ${contentModel.content_html!''}
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
      </div>
    </section>
  <@crafter.renderComponentCollection $field="footer_o" />
  <@crafter.body_bottom />
  <script src="/static-assets/js/header.js"></script>
  <script src="/static-assets/js/function.js"></script>
</body>

</html>