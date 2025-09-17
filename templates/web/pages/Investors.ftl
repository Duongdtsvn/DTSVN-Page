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
        <section class="section sec-projectFeature">
    <div class="container-custom">
        <div class="projectFeature-list">
            <#if contentModel.investors_o.item?? && contentModel.investors_o.item?has_content>
                <#list contentModel.investors_o.item as investors>
                    <div class="projectFeature">
                        <div class="row">
                            <div class="col-md-5 col-xxxl-4">
                                <a href="#" class="projectFeature__img"
                                    style="background-image: url('${investors.image_s!''}');"></a>
                            </div>
                            <div class="col-md-7 col-xxxl-6">
                                <div class="projectFeature__body">
                                    <h3 class="projectFeature__title">
                                        <a href="#">${investors.title_s!''}</a>
                                    </h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            </#if>
        </div>
    </div>
</section>
        <@crafter.renderComponentCollection $field="footer_o" />
    </main>
<script src="/static-assets/js/function.css"></script>
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>

    <@crafter.body_bottom />
</body>

</html>