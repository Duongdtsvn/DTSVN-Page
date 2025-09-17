<#import "/templates/system/common/crafter.ftl" as crafter />


<section class="section sec-motto">
            <div class="container-custom">
                <div class="row">
                    <div class="col-xl-10 offset-xl-1">
                        <div class="sec-motto__content wow fadeInUp">
                            <span class="sec-motto__quote">>
                                <@crafter.img $field="nh_bld_s" src=(contentModel.icon_s!"") alt="" />
                            </span>
                            <h3 class="sec-motto__title fz-40"> ${contentModel.title3_s!''}
                                <br>------------<br>
                                ${contentModel.author_s!''}
                            </h3>
                        </div>
                    </div>
                </div>
            </div>
        </section>