<#import "/templates/system/common/crafter.ftl" as crafter />


    <nav class="nav-cat">
        <#if contentModel.list_tab_o.item?has_content>
            <ul class="nav nav-tabs">
                <#list contentModel.list_tab_o.item as list_tab>
                    <li class="nav-item">
                        <button>${list_tab.name_tab_s!""}</button>
                    </li>
                </#list>
            </ul>
        </#if>
    </nav>

        <div class="tab-content mt-4">
            <div class="tab-pane fade show active">
                <div class="row">
                    <#if contentModel.list_tab_o.item?has_content>
                        <#list contentModel.list_tab_o.item as list_tab>
                            <#if list_tab.content_tab_o.item?? && list_tab.content_tab_o.item?has_content>
                                <#list list_tab.content_tab_o.item as module>
                                    <div class="col-md-6 col-lg-4">
                                        <@renderComponent component=module />
                                    </div>
                                </#list>
                            </#if>
                        </#list>
                    </#if>
                </div>
            </div>
        </div>