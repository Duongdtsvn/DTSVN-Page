<#import "/templates/system/common/crafter.ftl" as crafter />

<section class="section sec-teamLeader">
  <div class="container-custom">
    <div class="row">
      <div class="col-xl-5">
        <div class="titlebox">
          <h2 class="titlebox__title fz-44">Đội ngũ lãnh đạo tại DTSVN</h2>
        </div>
      </div>
    </div>

    <div class="sec-teamLeader__content">
      <div class="row">
        <#if contentModel.teambox_list_o.item?? && contentModel.teambox_list_o.item?has_content>
          <#list contentModel.teambox_list_o.item as teambox_list>
            <div class="col-6 col-lg-4 col-xl-2">
              <a href="#popup-team" class="teambox btn-popupTeam">
                <div class="teambox__inner">
                  <div class="teambox__img" style="background-image: url(${teambox_list.image_s!''});"></div>
                  <div class="teambox__body">
                    <h3 class="teambox__name">${teambox_list.name_s!''}</h3>
                    <p class="teambox__text">${teambox_list.position_s!''}</p>
                  </div>
                  <div class="teambox__list">
                    <ul>
                      <@crafter.renderComponentCollection model="teambox_list_o" />
                    </ul>
                  </div>
                </div>
              </a>
            </div>
          </#list>
        </#if>
      </div>
    </div>
  </div>
</section>