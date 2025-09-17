<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-productOrien">
    <div class="container-custom">
        <div class="sec-productOrien__testimonial">
            <div class="testimonial">
                <div class="row">
                    <div class="col-md-7 col-xl-7">
                        <div class="testimonial__content">
                            <span class="testimonial__subtitle sub-min">${contentModel.title_s!''}</span>
                            <h3 class="testimonial__quote">${contentModel.subtitle_s!''}</h3>
                            <p class="testimonial__info">
                                <b>${contentModel.name_s!''}</b>
                                ${contentModel.position_s!''}<br>
                                ${contentModel.company_s!''}
                            </p>
                            <div class="testimonial__footer">
                                <a href="partners-customer.html" class="btn-text">${contentModel.customer_dtsvn_s!''}<span></span></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-5 col-xl-5">
                        <div class="testimonial__img"
                            style="background-image: url('${contentModel.image_s!'/static-assets/images/placeholder.jpg'}');">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>