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
  <@crafter.renderComponentCollection $field="list_product_o" />
  <@crafter.renderComponentCollection $field="product_orientation_o" />
   <@crafter.renderComponentCollection $field="list_service_o" />
  <@crafter.renderComponentCollection $field="customer_stalk_about_o" />
  
  <@crafter.renderComponentCollection $field="reasons_choosing_o" />
  <@crafter.renderComponentCollection $field="footer_o" />
  <@crafter.body_bottom />
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>
</body>
</html>