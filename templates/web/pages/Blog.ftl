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
  <@crafter.renderComponentCollection $field="header_o" />
  <main class="page-content">
    <@crafter.renderComponentCollection $field="banner_blog_o" />
    <section class="section sec-blogPage">
        <div class="container-custom">
            <@crafter.renderComponentCollection $field="list_blog_o" />
        </div>
    </section>
  </main>
  <@crafter.renderComponentCollection $field="footer_o" />
  <@crafter.body_bottom />
</body>

</html>