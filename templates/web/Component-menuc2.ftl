<#import "/templates/system/common/crafter.ftl" as crafter />

<#if contentModel.submenu_o.item?? && contentModel.submenu_o.item?has_content>
  <#list contentModel.submenu_o.item as submenu>
    <li>
      <a href="${submenu.link_s!''}">${submenu.menu_s!''}</a>
    </li>
  </#list>
</#if>
