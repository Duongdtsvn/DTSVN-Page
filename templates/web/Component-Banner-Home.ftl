<#import "/templates/system/common/crafter.ftl" as crafter />


<section class="section sec-hero" style="height:100vh; display:flex; align-items:center;">
            <div class="sec-hero__inner" style="height:100%; width:100%;">
                <div class="sec-hero__bg" data-bg-mb="url(${contentModel.cover_mobile_s!''})"
                    data-bg-pc="url(${contentModel.cover_pc_s!''})"
                    style="background-image: url(${contentModel.cover_pc_s!''}); background-size:cover;
                    background-position:center;
                    width:100%;
                    height:100%;
                    position:absolute;
                    top:0;
                    left:0;"">
                </div>
                <div class="sec-hero__content" style="position:relative; z-index:1;">
                    <div class="container-custom">
                        <div class="row">
                            <div class="col-md-7 col-lg-5 col-xl-5">
                                <div class="wow fadeInUp">
                                    <h1 class="sec-hero__title">${contentModel.title1_s!''}
                                    </h1>
                                    <p class="sec-hero__text">${contentModel.subtitle1_s!''}</p>
                                    <div class="sec-hero__btn">
                                        <p class="sec-hero__text"><a href="/contact"
                                                class="btn btn-secondary-3">${contentModel.contact_s!''}</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>