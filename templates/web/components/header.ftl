<#import "/templates/system/common/crafter.ftl" as crafter />


<@crafter.header id="header">
  <div class="header">
    
    <a href="/" class="logo">
      <@crafter.img $field="logo_s,logo_text_t" src=(contentModel.logo_s!"") alt=(contentModel.logo_text_t!"") border=0 />
    </a>
    <ul class="nav-menu">
      <#list contentModel.navigationLinks_o![] as item>
        <li>
          <a href="${item.link_s!''}">${item.label_t!''}</a>
        </li>
      </#list>
    </ul>

    
    <div class="lang-switch">
      <div class="lang">
        <img src="${siteContext.staticAssetsUrl}/icons/flag-vn.png" alt="vi" />
        <span>vi</span>
      </div>
      <div class="lang">
        <img src="${siteContext.staticAssetsUrl}/icons/flag-en.png" alt="en" />
        <span>en</span>
      </div>
    </div>
  </div>
  <@crafter.renderComponentCollection $field="socialMediaWidget_o" />
</@crafter.header>
