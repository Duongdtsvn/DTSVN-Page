<#import "/templates/system/common/crafter.ftl" as crafter />
<#import "/templates/system/common/commonHead.ftl" as common />

<!doctype html>
<html lang="en" class="demo">

<head>
   <@common.commonHead />
    <@crafter.head />
</head>

<body>
    <@crafter.body_top />

    <main class="page-content">
        <@crafter.renderComponentCollection $field="header_o" />
        <@crafter.renderComponentCollection $field="banner_o" />
        <@crafter.renderComponentCollection $field="why_choose_o" />
        <#-- Defining the vision section challenges -->
<section class="section sec-vision">
    <div class="bg" style="background-image: url(${contentModel.vision_background_image_s!''});"></div>
    <div class="container-custom">
        <div class="row">
            <div class="col-xl-7 col-xxl-6 col-xxxl-5">
                <h2 class="item-quote">${contentModel.vision_title_s!''}</h2>
                <p class="item__text" style="color: white;">${contentModel.vision_description_s!''}</p>
            </div>
        </div>
        <div class="row">
            <div class="col-xl-8 offset-xl-4 col-xxl-6 offset-xxl-6">
                <div class="sec-vision__list">
                    <div class="row">
                        <#if contentModel.vision_challenges_o.item?? && contentModel.vision_challenges_o.item?has_content>
                            <#list contentModel.vision_challenges_o.item as challenge>
                                <div class="col-lg-6">
                                    <div class="item">
                                        <label class="item__label">
                                            <input type="checkbox">
                                            <h3 class="item__title">${challenge.title_s!''}</h3>
                                            <div class="item__content">
                                                <p class="item__text">${challenge.description_s!''}</p>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </#list>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<#-- Defining the strength section service packages -->
<section class="section sec-strength">
    <div class="container-custom">
        <div class="sec-strength__wrap">
            <div class="sec-strength__list owl-carousel">
                <div class="titlebox item">
                    <h2 class="titlebox__title fz-44">${contentModel.strength_title_s!''}</h2>
                </div>
                <#if contentModel.service_packages_o.item?? && contentModel.service_packages_o.item?has_content>
                    <#list contentModel.service_packages_o.item as service>
                        <div class="item">
                            <div class="featurebox" style="border: 1px solid #E3E5EA">
                                <div class="featurebox__inner">
                                    <span class="featurebox__icon"><img src="${service.icon_s!''}" alt=""></span>
                                    <div class="featurebox__body">
                                        <div class="translate" data-translate=".featurebox__text" style="--y: 90px">
                                            <span class="featurebox__number">${service.number_s!''}</span>
                                            <h3 class="featurebox__title">${service.title_s!''}</h3>
                                            <p class="featurebox__text" style="visibility: visible;">${service.description_html!''}</p>
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

<#-- Defining the team leader section -->
<section class="section sec-teamLeader">
    <div class="container-custom">
        <div class="row">
            <div class="col-xl-5">
                <div class="titlebox">
                    <h2 class="titlebox__title fz-44">${contentModel.team_title_s!''}</h2>
                    <p class="titlebox__text">${contentModel.team_description_s!''}</p>
                </div>
            </div>
        </div>
        <div class="sec-teamLeader__content">
            <div class="row">
                <#if contentModel.team_members_o.item?? && contentModel.team_members_o.item?has_content>
                    <#list contentModel.team_members_o.item as member>
                        <div class="col-6 col-lg-4 col-xl-3">
                            <a href="#popup-team" class="teambox btn-popupTeam">
                                <div class="teambox__inner">
                                    <div class="teambox__img" style="background-image: url(${member.image_s!''});"></div>
                                    <div class="teambox__body">
                                        <h3 class="teambox__name">${member.name_s!''}</h3>
                                        <p class="teambox__text">${member.position_s!''}</p>
                                    </div>
                                    <div class="teambox__list">
                                    <ul>
                                        <@crafter.renderComponentCollection model="teambox_list_o" />
                                      </ul>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </#list>
                </#if>
            </div>
        </div>
    </div>
</section>

<div class="modal-team" id="popup-team">
    <div class="modal-team__bg"></div>
    <div class="modal-team__inner">
        <div class="modal-team__content">
            <span class="modal-team__close">
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12.59 0L7 5.59L1.41 0L0 1.41L5.59 7L0 12.59L1.41 14L7 8.41L12.59 14L14 12.59L8.41 7L14 1.41L12.59 0Z" fill="black" />
                </svg>
            </span>

            <div class="modal-team__img" style="background-image: url(assets/img/teambox-1.jpg);"></div>
            <div class="modal-team__body">
                <span class="modal-team__subtitle">Deputy CEO of Professional Service</span>
                <h2 class="modal-team__title">Trần Bá Trọng</h2>
                <div class="modal-team__list">
                    <ul>
                        <li>
                            <div class="item-inner">
                                <span>01</span>
                                <div class="row">
                                    <div class="col-xl-5">
                                        <h3>Trình độ <br>học vấn</h3>
                                    </div>
                                    <div class="col-xl-6 offset-xl-1">
                                        <p>Tốt nghiệp Đại học khoa học xã hội và nhân văn - ĐHQGHN</p>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li>
                            <div class="item-inner">
                                <span>02</span>
                                <div class="row">
                                    <div class="col-xl-5">
                                        <h3>Kinh nghiệm <br>làm việc</h3>
                                    </div>
                                    <div class="col-xl-6 offset-xl-1">
                                        <p>Có hơn 5 năm kinh Nghiêm triển khai trực tiếp các dự án lớn tại Ngân hàng</p>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li>
                            <div class="item-inner">
                                <span>03</span>
                                <div class="row">
                                    <div class="col-xl-5">
                                        <h3>Lĩnh vực <br>chuyên môn</h3>
                                    </div>
                                    <div class="col-xl-6 offset-xl-1">
                                        <p>Trên 10 năm triển khai các hệ thống lớn và phức tạp cho khách hàng trong và ngoài nước.</p>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

        
        <@crafter.renderComponentCollection $field="member_o" />
        <@crafter.renderComponentCollection $field="footer_o" />
    </main>
    
<script src="/static-assets/js/function.js"></script>
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>


    <@crafter.body_bottom />
</body>

</html>