<#import "/templates/system/common/crafter.ftl" as crafter />

<!DOCTYPE HTML>
<html lang="${contentModel.language_s!"vi"}">
<head>
  <meta charset="UTF-8"/>
  <#assign 
    pageTitle = (contentModel.language_s == "en")?then(contentModel.title_en_s!'', contentModel.title_vi_s!'')
    pageDescription = (contentModel.language_s == "en")?then(contentModel.description_en_t!'', contentModel.description_vi_t!'')
    pageLang = contentModel.language_s!"vi"
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
                <a href="${contentModel.storeUrl}" class="active">VN</a>
                <a href="${contentModel.storeUrl}?lang=en">EN</a>
              </div>
              <h1 class="pageInner__title">
                ${pageTitle}
              </h1>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Content -->
    <section class="section sec-content">
      <div class="container-custom">
        <div class="row">
          <div class="col-12">
            <div class="content-wrapper">
              ${pageDescription}
            </div>
          </div>
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