<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-clientList">
    <div class="container-custom">
        <div class="row">
            <div class="col-md-8 col-lg-5 col-xl-7">
                <div class="titlebox">
                    <h2 class="titlebox__title fz-44">${contentModel.title5_s!''}</h2>
                </div>
            </div>
        </div>
        <div class="clientList">
            <div class="row">
                <#if contentModel.member_o.item?? && contentModel.member_o.item?has_content>
                    <#list contentModel.member_o.item as member>
                        <div class="col-4 col-md-3 col-xl-3">
                            <a class="clientbox" href="${contentModel.url_s!'#'}">
                                <div class="clientbox__inner">
                                    <@crafter.img $field="image_s" src=(member.image_member_s!"") alt="" />
                                </div>
                            </a>
                        </div>
                    </#list>
                </#if>
            </div>
        </div>
    </div>
</section>