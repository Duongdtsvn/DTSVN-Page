<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-strength">
    <div class="container-custom">
        <div class="sec-strength__wrap">
            
            <div class="sec-strength__list owl-carousel">
            <div class="titlebox item">
                <span class="titlebox__title">${contentModel.title_s!''}</span>
                <h2 class="titlebox__title fz-44" >${contentModel.subtitle_s!''}</h2>
            </div>
                <#if contentModel.why_choose_o.item?? && contentModel.why_choose_o.item?has_content>
                    <#list contentModel.why_choose_o.item as why_choose>
                        <div class="item">
                            <div class="featurebox">
                                <div class="featurebox__inner">
                                    <span class="featurebox__icon"><img
                                            src="${why_choose.icon_s!''}"
                                            alt=""></span>
                                    <div class="featurebox__body">
                                        <div class="translate" data-translate=".featurebox__text" style="--y: 90px">
                                            <span class="featurebox__number">${why_choose.number_s!''}</span>
                                            <h3 class="featurebox__title">${why_choose.title_s!''}</h3>
                                            <p class="featurebox__text" style="visibility: visible;">${why_choose.subtitle_s!''}</p>
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
</section>