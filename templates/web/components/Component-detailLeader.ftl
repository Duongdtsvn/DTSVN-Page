
<#import "/templates/system/common/crafter.ftl" as crafter />

<#if contentModel.detail_o.item?? && contentModel.detail_o.item?has_content>
  <#list contentModel.detail_o.item as detail>
    <li>
      <div class="item-inner">
        <span>${detail.number_s!''}</span>
        <div class="row">
          <div class="col-xl-5">
            <h3>${detail.title_s!''}</h3>
          </div>
          <div class="col-xl-6 offset-xl-1">
            <p>${detail.subtitle_s!''}</p>
          </div>
        </div>
      </div>
    </li>
  </#list>
</#if>
