<#import "/templates/system/common/crafter.ftl" as crafter />
<!-- Footer -->
<footer class="footer">
    <div class="container-custom">
        <div class="footer__content">
            <div class="row">
                <div class="col-xl-4">
                    <div class="footer__widget">
                        <div class="footer__info">
                            <div class="item-logo">
                                <a href="/home">
                                    <@crafter.img $field="logo_dtsvn_s" src=(contentModel.logo_dtsvn_s!"") alt="" />
                                </a>
                            </div>
                            <p class="item-text">
                                ${contentModel.address_s!''}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-xl-8">
                    <div class="row">
                        <div class="col-7 col-md-3">
                            <div class="footer__widget">
                                <ul class="footer__contact">
                                    <#if contentModel.contact_information_o.item?? &&
                                        contentModel.contact_information_o.item?has_content>
                                        <#list contentModel.contact_information_o.item as contact_information>
                                            <li>
                                                <small> ${contact_information.information_1_s!''}</small>
                                                <p><a href="tel:(+84) 912 363 824">
                                                        ${contact_information.information_2_s!''}</a></p>
                                            </li>
                                        </#list>
                                    </#if>
                                </ul>
                            </div>
                        </div>
                        <div class="col-md-4 col-xxxl-3 d-none d-md-block">
                            <div class="footer__widget">
                                <h3 class="item-title">${contentModel.member_company_s!''}</h3>
                                <ul class="footer__list">
                                    <#if contentModel.member_company_o.item?? && contentModel.member_company_o.item?has_content>
                                        <#list contentModel.member_company_o.item as member_company>
                                            <li><a href="${member_company.link_s!''}">${member_company.name_company_s!''}</a></li>
                                        </#list>
                                    </#if>
                                </ul>
                            </div>
                        </div>
                        <div class="col-md-2 col-lg-3 col-xl-3 d-none d-md-block">
                            <div class="footer__widget">
                                <h3 class="item-title">${contentModel.social_network_s!''}</h3>
                                <ul class="footer__list">
                                    <#if contentModel.social_network_o.item?? && contentModel.social_network_o.item?has_content>
                                        <#list contentModel.social_network_o.item as social_network>
                                            <li><a href="${social_network.link_s!''}">${social_network.name_social_s!''}</a></li>
                                        </#list>
                                    </#if>
                                </ul>
                            </div>
                        </div>
                        <div class="col-5 col-md-3 col-lg-2 col-xxxl-3">
                            <div class="footer__widget">
                                <ul class="footer__list big">
                                    <#if contentModel.menu_footer_o.item?? && contentModel.menu_footer_o.item?has_content>
                                        <#list contentModel.menu_footer_o.item as menu_footer>
                                            <li><a href="${menu_footer.link_s!''}">${menu_footer.menu_s!''}</a></li>
                                        </#list>
                                    </#if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer__footer">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="footer__copyright">© Bản quyền thuộc về DTSVN</p>
                </div>
                <div class="col-md-6 d-none d-md-block">
                    <div class="footer__desgin">Thiết kế bởi © <a href="https://beau.vn/">DTSVN</a></div>
                </div>
            </div>
        </div>
    </div>
</footer>