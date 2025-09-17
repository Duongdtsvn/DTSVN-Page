<#import "/templates/system/common/crafter.ftl" as crafter />

<#if contentModel.category_s?has_content>
  <#if articles?? && articles?has_content>
    <#list articles as article>
      <div class="blog">
        <div class="blog__inner">
          <div class="blog__img"
               style="background-image: url('${article.image_s!'/static-assets/images/placeholder.jpg'}');">
            <img src="${article.image_s!'/static-assets/images/placeholder.jpg'}" alt="">
          </div>
          <div class="blog__body">
            <h3 class="blog__title">${article.title_s!''}</h3>
            <ul class="postMin__meta">
              <li>${article.date_s!''}</li>
            </ul>
          </div>
        </div>
      </div>
    </#list>
  <#else>
    <p>Không có bài viết nào trong danh mục này.</p>
  </#if>
<#else>
  <p>Không tìm thấy danh mục.</p>
</#if>