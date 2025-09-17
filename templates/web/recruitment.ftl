<#import "/templates/system/common/crafter.ftl" as crafter />

<!DOCTYPE HTML>
<html lang="${contentModel.language_s!"vi"}">
<head>
  <meta charset="UTF-8"/>
  <#assign 
    pageLang = contentModel.language_s!"vi"
    pageTitle = (pageLang == "en")?then("Recruitment", "Tuyển dụng")
    noJobsMessage = (pageLang == "en")?then(
      {"title": "No positions available", "desc": "Please check back later."}, 
      {"title": "Không tìm thấy vị trí tuyển dụng nào", "desc": "Vui lòng thử lại sau."}
    )
    prevText = (pageLang == "en")?then("Previous", "Trang trước")
    nextText = (pageLang == "en")?then("Next", "Trang sau")
  />
  <title>${pageTitle} - DTSVN</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
  <link rel="stylesheet" href="/static-assets/css/main.css?v=${siteContext.siteName}"/>
</head>
<body>
  <div id="page-wrapper">
    <!-- Header -->
    <@renderComponent componentPath="/site/components/headers/header.xml" />

    <!-- Main -->
    <section class="section sec-pageInner">
      <div class="container-custom">
        <div class="row">
          <div class="col-12">
            <div class="pageInner__heading">
              <div class="langSwitch">
                <a href="/recruitment" class="active">VN</a>
                <a href="/recruitment?lang=en">EN</a>
              </div>
              <h1 class="pageInner__title">${pageTitle}</h1>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Jobs List -->
    <section class="section sec-projectFeature">
      <div class="container-custom">
        <div class="projectFeature-list">
          <#if recruitmentItems?? && (recruitmentItems?size > 0)>
            <#list recruitmentItems as recruitment>
              <div class="projectFeature">
                <div class="row">
                  <div class="col-md-5 col-xxxl-4">
                    <a href="${(pageLang == "en")?then(recruitment.url_en!'', recruitment.url!'')}" class="projectFeature__img" 
                      style="background-image: url('${(recruitment.img_main_s?? && recruitment.img_main_s?length > 0)?then(recruitment.img_main_s, '/static-assets/images/recruitment/default.jpg')}');">
                    </a>
                  </div>
                  <div class="col-md-7 col-xxxl-6">
                    <div class="projectFeature__body">
                      <h3 class="projectFeature__title">
                        <a href="${(pageLang == "en")?then(recruitment.url_en!'', recruitment.url!'')}">${(pageLang == "en")?then(recruitment.title_en!'', recruitment.title!'')}</a>
                      </h3>
                      <div class="projectFeature__text">
                        <p>${(pageLang == "en")?then(recruitment.description_en!'', recruitment.description!'')}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </#list>
          <#else>
            <div class="col-12">
              <div class="text-center py-5">
                <h3>${noJobsMessage.title}</h3>
                <p>${noJobsMessage.desc}</p>
              </div>
            </div>
          </#if>

          <!-- Pagination -->
          <#if totalPages?? && (totalPages > 1)>
            <div class="pagination">
              <div class="pagination__inner">
                <#if hasPrevPage>
                  <a href="?page=${currentPage - 1}${(pageLang == 'en')?then('&lang=en','')}" class="prev">${prevText}</a>
                </#if>

                <div class="pagination__numbers">
                  <#list pageNumbers as pageNumber>
                    <a href="?page=${pageNumber}${(pageLang == 'en')?then('&lang=en','')}" class="${(pageNumber == currentPage)?then('active', '')}">${pageNumber}</a>
                  </#list>
                </div>

                <#if hasNextPage>
                  <a href="?page=${currentPage + 1}${(pageLang == 'en')?then('&lang=en','')}" class="next">${nextText}</a>
                </#if>
              </div>
            </div>
          </#if>
        </div>
      </div>
    </section>
  </div>

  <@renderComponent componentPath="/site/components/footers/footer.xml" />

  <!-- Scripts -->
  <script src="/static-assets/js/jquery.min.js"></script>
  <script src="/static-assets/js/main.js?site=${siteContext.siteName}"></script>
</body>
</html>