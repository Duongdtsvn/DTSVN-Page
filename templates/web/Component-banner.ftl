<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-pageTitle style-productF style-2">
  <div class="sec-pageTitle__wrap">
      <ul class="sec-pageTitle__breadcrumb">
          <li><a href="/">Trang chủ</a></li>
          <li><span>${contentModel.name_page_s!''}</span></li>
      </ul>
      <div class="sec-pageTitle__content">
          <div class="container-custom">
              <div class="row">
                  <div class="col-lg-9">
                      <h1 class="sec-pageTitle__title fz-52">${contentModel.title_s!''}</h1>
                      <p class="sec-pageTitle__text">${contentModel.subtitle_s!''}</p>
                  </div>
              </div>
          </div>
      </div>
  </div>
</section>