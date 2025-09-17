<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-projectFeature">
  <div class="container-custom">
    <div class="projectFeature-list">
      <#if contentModel.project_o.item?? && contentModel.project_o.item?has_content>
        <#list contentModel.project_o.item as project>
          <div class="projectFeature">
            <div class="row">
              <div class="col-md-5 col-xxxl-4">
                <a href="#" class="projectFeature__img" style="background-image: url(${project.subtitle1_s!''});"></a>
              </div>
              <div class="col-md-7 col-xxxl-6">
                <div class="projectFeature__body">
                  <h3 class="projectFeature__title">
                    <a href="#">${project.subtitle1_s!''}</a>
                  </h3>
                  <div class="projectFeature__text">
                    <p>${project.subtitle1_s!''}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </#list>
      </#if>
    </div>
  </div>
</section>