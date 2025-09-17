<#macro commonHead title="DTSVN" description="Giải Pháp Phần Mềm Số Cho Ngành Tài Chính & Ngân Hàng" image="/static-assets/images/logo/dtsvn_logomark_color.png" url="">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <!-- Title hiển thị trên tab -->
  <title>${description}</title>
  <link rel="shortcut icon" href="/static-assets/images/logo/dtsvn_logomark_color.png" />

  <!-- Open Graph -->
  <meta property="og:site_name" content="DTSVN" />
  <meta property="og:url" content="${url}" />
  <meta property="og:title" content="${title}" />
  <meta property="og:description" content="${description}" />
  <meta property="og:image" content="${image}" />

  <!-- Twitter -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="${title}" />
  <meta name="twitter:description" content="${description}" />
  <meta name="twitter:image" content="${image}" />
  <!-- CSS -->
  <link rel="stylesheet" href="/static-assets/css/header.css" />
  <link rel="stylesheet" href="/static-assets/css/main.css" />

  <!-- JS -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script>

</#macro>
