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
        <@crafter.renderComponentCollection $field="who_studies_o" />
        <@crafter.renderComponentCollection $field="target_o" />
        <@crafter.renderComponentCollection $field="why_choose_o" />
        <section class="section pb-0">
                <div class="container-custom">
                    <div class="row">
                        <div class="col-xl-12">
                            <@crafter.img $field="image_s" src=(contentModel.image_s!"") alt="" />
                        </div>
                    </div>
                </div>
            </section>
        <@crafter.renderComponentCollection $field="result_o" />
        <@crafter.renderComponentCollection $field="course_information_o" />
        <@crafter.renderComponentCollection $field="teacher_ba_o" />
        <@crafter.renderComponentCollection $field="footer_o" />
    </main>
<script src="/static-assets/js/function.css"></script>
<script src="/static-assets/js/header.css"></script>
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>

    <@crafter.body_bottom />
</body>

</html>