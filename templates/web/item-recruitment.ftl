<#import "/templates/system/common/crafter.ftl" as crafter />

<!doctype html>
<html lang="vi">
    <head>
        <#include "/templates/web/fragments/head.ftl" />
        <@crafter.head/>
    </head>
    <body>
        <div id="wrapper">
            <!-- Main -->
            <div id="main">
                <div class="inner">
                    <!-- Header -->
                    <@renderComponent componentPath="/site/components/headers/header.xml" />

                    <!-- Content -->
                    <section class="section">
                        <div class="container-custom">
                            <div class="row">
                                <div class="col-12">
                                    <!-- Image -->
                                    <#if contentModel.img_main_s?? && contentModel.img_main_s != "">
                                        <img class="img-fluid mb-4" src="${contentModel.img_main_s}" alt="${contentModel.title_vi_s!''}" />
                                    </#if>

                                    <!-- Vietnamese Content -->
                                    <div class="content-vi mb-5">
                                        <h1>${contentModel.title_vi_s!''}</h1>
                                        <div class="content">
                                            ${contentModel.content_vi_html!''}
                                        </div>
                                    </div>

                                    <!-- English Content -->
                                    <div class="content-en">
                                        <h1>${contentModel.title_en_s!''}</h1>
                                        <div class="content">
                                            ${contentModel.content_en_html!''}
                                        </div>
                                    </div>

                                    <!-- Apply Button -->
                                    <div class="text-center mt-4">
                                        <a href="/contact-us" class="button primary large">Ứng tuyển ngay / Apply Now</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>

            <!-- Sidebar -->
            <@renderComponent componentPath="/site/components/sidebars/sidebar.xml" />
        </div>

        <#include "/templates/web/fragments/scripts.ftl" />
        <@crafter.body_bottom />
    </body>
</html>