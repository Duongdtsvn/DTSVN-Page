<#-- Import template engine để sử dụng các macro và function của Crafter CMS -->
<#import "/templates/system/common/crafter.ftl" as crafter />

<body class="home">
  <!-- Header Section - Phần đầu trang web -->
  <header class="nav-header">
    <div class="nav-container">
      <div class="nav-content">
        <!-- Logo Section - Phần logo công ty -->
        <div class="nav-logo">
          <a href="/">
            <span class="svg-container">
              <!-- SVG Logo - Logo vector của công ty với màu xanh dương -->
              <svg width="144" height="30" viewBox="0 0 144 30" fill="none" xmlns="http://www.w3.org/2000/svg">
                <!-- Các hình khối logo -->
                <path d="M10.0332 0H0V18.3333H10.0332V0Z" fill="#2B6BB2" />
                <path d="M30.0994 0H11.7051V10H30.0994V0Z" fill="#2B6BB2" />
                <path d="M30.0997 11.667H20.0664V30.0003H30.0997V11.667Z" fill="#2B6BB2" />
                <path d="M18.3943 20H0V30H18.3943V20Z" fill="#2B6BB2" />
                <!-- Chữ "TECH" trong logo -->
                <path
                  d="M52.2553 3.06641C55.5394 3.06641 58.2763 4.22571 60.4314 6.51013C62.6208 8.79461 63.7156 11.6246 63.7156 15.0001C63.7156 18.3415 62.6209 21.1715 60.4314 23.4901C58.2763 25.7745 55.5394 26.9338 52.2553 26.9338H42.8477V3.06641H52.2553ZM52.2553 23.1832C54.5132 23.1832 56.3605 22.399 57.7631 20.8647C59.1999 19.3303 59.9183 17.3528 59.9183 15.0001C59.9183 12.6133 59.1999 10.6699 57.7631 9.13556C56.3605 7.60124 54.5132 6.81702 52.2553 6.81702H46.7817V23.1832H52.2553Z"
                  fill="#0E245B" />
                <!-- Chữ "SOLUTIONS" trong logo -->
                <path
                  d="M82.8848 21.5124L86.2715 19.5348C87.2294 22.2285 89.2135 23.5582 92.224 23.5582C95.2003 23.5582 96.6713 22.2966 96.6713 20.4214C96.6888 19.979 96.587 19.54 96.3764 19.1502C96.1658 18.7604 95.8541 18.434 95.4739 18.2051C94.6871 17.6936 93.2503 17.114 91.2319 16.5003C88.9399 15.8183 87.811 15.3751 86.2031 14.3181C84.6637 13.227 83.8769 11.6586 83.8769 9.51056C83.8769 7.39658 84.6295 5.72586 86.1347 4.49839C87.6399 3.23683 89.453 2.62305 91.574 2.62305C95.4055 2.62305 98.3818 4.60064 99.9212 7.87392L96.6029 9.78332C95.6108 7.56703 93.9345 6.44185 91.574 6.44185C89.282 6.44185 87.811 7.60116 87.811 9.40824C87.811 11.1813 88.9741 11.9995 92.6345 13.1247C93.5582 13.4316 94.2082 13.6362 94.6187 13.8066C95.0634 13.9431 95.645 14.1817 96.3976 14.4886C97.0243 14.7171 97.6125 15.039 98.1423 15.4433C99.408 16.4321 100.776 18.0687 100.605 20.3531C100.605 22.5012 99.8185 24.2401 98.2449 25.5017C96.7055 26.7632 94.6529 27.377 92.1214 27.377C87.5031 27.377 84.1505 25.1607 82.8848 21.5124Z"
                  fill="#0E245B" />
                <!-- Chữ "VIETNAM" trong logo -->
                <path
                  d="M109.432 26.9338L101.119 3.06641H105.43L111.792 22.1944L118.19 3.06641H122.466L114.153 26.9338H109.432Z"
                  fill="#0E245B" />
                <!-- Chữ "TECH" thứ hai trong logo -->
                <path
                  d="M139.399 3.06641H143.333V26.9338H140.255L128.965 10.7381V26.9338H125.031V3.06641H128.11L139.399 19.2622V3.06641Z"
                  fill="#0E245B" />
                <!-- Chữ "SOLUTIONS" thứ hai trong logo -->
                <path
                  d="M64.0586 3.06641V6.81707H70.8321V26.9339H74.7662V6.81707H82.1642C82.6114 5.3957 83.473 4.13914 84.639 3.20735C84.6961 3.15973 84.7536 3.11275 84.8115 3.06641H64.0586Z"
                  fill="#0E245B" />
              </svg>
            </span>
          </a>
        </div>

       

        <!-- Desktop Navigation Menu - Menu điều hướng cho desktop -->
        <nav class="nav-desktop">
  <ul class="nav-list" style="margin-bottom: 0px;">
    <#list contentModel.menu_o.item as menu>
  <li class="nav-has-submenu">
    <a href="${menu.link_s!''}">${menu.menu_s!''}</a>
  </li>
</#list>


  </ul>
</nav>


        <!-- Language Switcher - Bộ chuyển đổi ngôn ngữ -->
        <div class="nav-lang-switcher">
          <button class="lang-btn" id="lang-toggle" data-current-lang="VN">VN</button>
        </div>
         <!-- Hamburger Menu Button - Nút menu cho mobile -->
        <button class="nav-toggle">☰</button>
      </div>
    </div>
  </header>
  
  <!-- Spacer để tránh content bị che bởi fixed header -->
  <div class="nav-spacer"></div>

  <!-- Mobile Menu Overlay - Menu overlay cho mobile -->
  <div class="nav-mobile">
    <div class="nav-mobile__container">
      <div class="nav-mobile__content">
        <nav class="nav-mobile__menu">
          <ul class="nav-list">
            <!-- Loop qua menu items cho mobile - Vòng lặp hiển thị menu mobile từ CMS -->
            <#if contentModel.menu_o.item?? && contentModel.menu_o.item?has_content>
            <#list contentModel.menu_o.item as menu>
            <li class="nav-has-submenu">
              <a href="${menu.link_s!''}">${menu.menu_s!''}</a>
            </li>
            </#list>
            </#if>
          </ul>
        </nav>
        
      </div>
    </div>
  </div>
  <!-- End Header -->
</body>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const currentUrl = window.location.pathname; // lấy path hiện tại
    const menuLinks = document.querySelectorAll(".nav-list li a");

    menuLinks.forEach(link => {
      if (link.getAttribute("href") === currentUrl) {
        link.classList.add("active");
      }
    });
  });
</script>

  <!-- <script src="/static-assets/js/header.js?site=${siteContext.siteName}"></script> -->
</html>