<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-clientList" style="padding-top: 0px !important">
            <div class="container-custom">
                <div class="row">
                    <div class="col-md-8 col-lg-5 col-xl-7">
                        <div class="titlebox">
                            <h2 class="titlebox__title fz-44">${contentModel.title6_s!''}</h2>
                        </div>
                    </div>
                </div>
                <div class="clientList">
                    <div class="row">
                        <#if contentModel.partner_o.item?? && contentModel.partner_o.item?has_content>
                            <#list contentModel.partner_o.item as partner>
                                <div class="col-4 col-md-3 col-xl-2">
                                    <a class="clientbox" href="https://clevertap.com/">
                                        <div class="clientbox__inner">
                                            <@crafter.img $field="image_s" src=(partner.image_partner_s!"") alt="" />
                                        </div>
                                    </a>
                                </div>
                            </#list>
                        </#if>
                    </div>
                </div>
            </div>
</section>