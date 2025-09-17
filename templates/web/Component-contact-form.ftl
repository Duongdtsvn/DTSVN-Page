<#import "/templates/system/common/crafter.ftl" as crafter />

    <div class="col-xxxl-10 offset-xxxl-1">
        <div class="sec-blogDetail__content stickyJs">
            <div class="row">
                <div class="col-xl-8 col-xxxl-7">
                    <div class="entry-text">
                        <br>
                        <h3 class="sec-contactPage__title text-center">${contentModel.title_main_s!''}</h3>
                        <div class="wpcf7 js" id="wpcf7-f6-o1" lang="vi" dir="ltr">
                            <div class="screen-reader-response">
                                <p role="status" aria-live="polite" aria-atomic="true"></p>
                                <ul></ul>
                            </div>
                            <form action="/dtsvn-d-ecs-phan-mem-canh-bao-rui-ro-no-som-va-theo-doi-nhac-no/#wpcf7-f6-o1" method="post" class="wpcf7-form init" aria-label="Form liên hệ" novalidate="novalidate" data-status="init">
                                <div style="display: none;">
                                    <input type="hidden" name="_wpcf7" value="6">
                                    <input type="hidden" name="_wpcf7_version" value="5.9.8">
                                    <input type="hidden" name="_wpcf7_locale" value="vi">
                                    <input type="hidden" name="_wpcf7_unit_tag" value="wpcf7-f6-o1">
                                    <input type="hidden" name="_wpcf7_container_post" value="0">
                                    <input type="hidden" name="_wpcf7_posted_data_hash" value="">
                                </div>
                                <#if contentModel.list_input_o.item?has_content>
                                    <div class="row g-3">
                                        <#list contentModel.list_input_o.item as form>
                                            <#if form.fied_name_s?? && form.fied_name_s == "your-message">
                                                <div class="col-12">
                                                    <div class="form-item">
                                                        <span class="wpcf7-form-control-wrap" data-name="${form.fied_name_s!''}">
                                                            <textarea cols="40" rows="10" maxlength="2000" class="wpcf7-form-control wpcf7-textarea" aria-invalid="false" placeholder="${form.label_name_s!''}*" name="${form.fied_name_s!''}"></textarea>
                                                        </span>
                                                    </div>
                                                </div>
                                            <#elseif form.fied_name_s?? && form.fied_name_s == "your-email">
                                                <div class="col-md-6">
                                                    <div class="form-item">
                                                        <span class="wpcf7-form-control-wrap" data-name="${form.fied_name_s!''}">
                                                            <input size="40" maxlength="400" class="wpcf7-form-control wpcf7-email wpcf7-validates-as-required wpcf7-text wpcf7-validates-as-email" autocomplete="${form.autocomplete_s!''}" aria-required="true" aria-invalid="false" placeholder="${form.label_name_s!''}*" value="" type="email" name="${form.fied_name_s!''}">
                                                        </span>
                                                    </div>
                                                </div>
                                            <#else>
                                                <div class="col-md-6">
                                                    <div class="form-item">
                                                        <span class="wpcf7-form-control-wrap" data-name="${form.fied_name_s!''}">
                                                            <input size="40" maxlength="400" class="wpcf7-form-control wpcf7-text wpcf7-validates-as-required" autocomplete="${form.autocomplete_s!''}" aria-required="true" aria-invalid="false" placeholder="${form.label_name_s!''}*" value="" type="text" name="${form.fied_name_s!''}">
                                                        </span>
                                                    </div>
                                                </div>
                                            </#if>
                                        </#list>
                                       <div class="col-12 text-center">
  <div class="form-btn">
    <a href="/404" class="wpcf7-form-control wpcf7-submit has-spinner">
      ${contentModel.label_button_s!''}
    </a>
  </div>
</div>

                                    </div>
                                </#if>
                                <div class="wpcf7-response-output" aria-hidden="true"></div>
                            </form>
                        </div>
                    </div>
                    <div class="entry-share text-center mt-4">
                        <span>${contentModel.label_share_s!''}:</span>
                        <a href="http://www.facebook.com/sharer.php?u=https://dtsvn.net/dtsvn-d-ecs-phan-mem-canh-bao-rui-ro-no-som-va-theo-doi-nhac-no/&amp;p[title]=Phát triển phần mềm thẩm định dữ liệu, phần mềm web-based">
                            <img src="https://dtsvn.net/wp-content/themes/dtsvn-hello-elementor/assets/img/icon-facebook.svg" alt="">
                        </a>
                        <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://dtsvn.net/dtsvn-d-ecs-phan-mem-canh-bao-rui-ro-no-som-va-theo-doi-nhac-no/">
                            <img src="https://dtsvn.net/wp-content/themes/dtsvn-hello-elementor/assets/img/icon-linkedin.svg" alt="">
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
