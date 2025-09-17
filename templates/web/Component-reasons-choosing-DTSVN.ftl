<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-whychoose">
    <div class="container-custom">
        <div class="row">
            <div class="col-lg-8 col-xl-6 col-xxxl-5">
                <div class="titlebox">
                    <span class="titlebox__subtitle">${contentModel.title_s!''}</span>
                    <h2 class="titlebox__title fz-32">${contentModel.subtitle_s!''}</h2>
                </div>
            </div>
        </div>
        <div class="sec-whychoose__list">
            <div class="row">
                <#if contentModel.reasons_choosing_o.item?? && contentModel.reasons_choosing_o.item?has_content>
                    <#list contentModel.reasons_choosing_o.item as reasons_choosing>
                        <div class="col-md-6 col-xl-4">
                            <div class="item">
                                <h2 class="item__title">${reasons_choosing.title_s!''}</h2>
                                <p class="item__text">${reasons_choosing.subtitle_s!''}</p>
                            </div>
                        </div>
                    </#list>
                </#if>
            </div>
        </div>
    </div>
</section>