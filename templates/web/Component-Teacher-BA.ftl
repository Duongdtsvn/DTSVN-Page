<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-productOrien pt-0">
  <div class="container-custom">
      <div class="sec-productOrien__testimonial">
          <div class="testimonial">
              <div class="row">
                  <div class="col-md-7 col-xl-7">
                      <div class="testimonial__content">
                          <span class="testimonial__quote">${contentModel.title_s!''}</span>
                          <br><br><p class="testimonial__subtitle">
                            ${contentModel.subtitle1_s!''}
                              <br></br>
                              ${contentModel.subtitle2_s!''}
                              <br></br>
                              ${contentModel.subtitle3_s!''}
                          </p>

                          <p class="testimonial__info">
                              <b>${contentModel.name_teacher_s!''}</b>
                              ${contentModel.work_at_s!''}
                          </p>
                      </div>
                  </div>
                  <div class="col-md-5 col-xl-5">
                      <div class="testimonial__img" style="background-image: url(${contentModel.image_s!''});"></div>
                  </div>
              </div>
          </div>
      </div>
  </div>
</section>