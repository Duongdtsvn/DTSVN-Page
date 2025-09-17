document.addEventListener('DOMContentLoaded', () => {
  const toggleButton = document.querySelector('.nav-toggle');
  const mobileNav = document.querySelector('.nav-mobile');
  const submenuLinks = document.querySelectorAll('.nav-mobile__menu .nav-has-submenu > a');
  const langToggle = document.getElementById('lang-toggle');

  // Function to determine current language from URL
  function getCurrentLanguage() {
    const path = window.location.pathname;
    return path.startsWith('/en/') ? 'EN' : 'VN';
  }
  
  // UUID
    const LOOK_LIKE_UUID = /^[0-9a-fA-F]+(-[0-9a-fA-F]+){4}$/;
    function pathEndsWithUuid(pathname) {
      const last = pathname.replace(/\/+$/,'').split('/').pop() || '';
      return LOOK_LIKE_UUID.test(last);
    }

  // Function to switch language and update URL
//   function switchLanguage() {
//     const currentPath = window.location.pathname;
//     const currentLang = getCurrentLanguage();
//     const targetLang = currentLang == 'VN' ? 'en' : 'vi';
    
//     let newPath;
//         if (currentLang === 'VN') {
//             // Switch from Vietnamese to English
//             if (currentPath === '/') {
//                 newPath = '/en/';
//             } 
//             else {
//                 if(!currentPath.startsWith('/en/') && targetLang == 'en'){
//                     newPath = '/en' + currentPath;
//                 }
                
//                 else{
//                     const params = new URLSearchParams(window.location.search);
//                     params.set('lang', currentLang === 'VN' ? 'en' : 'vi');
                        
//                     // Nếu currentPath đã có query string sẵn thì nối thêm bằng "&"
//                     if (currentPath.includes("?")) {
//                         newPath = currentPath.split("?")[0] + "?" + params.toString();
//                     } else {
//                         newPath = currentPath + "?" + params.toString();
//                     }
//                   }
//             }
//         } else {
//             // Switch from English to Vietnamese
//             if (currentPath.startsWith('/en/')) {
//                 newPath = currentPath.replace('/en/', '/');
//                 if (newPath === '/') {
//                   newPath = '/';
//                 }
//             } else {
//                 newPath = currentPath.replace('/en', '');
//             }
//         }

//         // Navigate to new URL
//         window.location.href = newPath;
//   }
  function switchLanguage() {
    const currentPath = window.location.pathname;
    const currentLang = getCurrentLanguage();
    const targetLang = currentLang == 'VN' ? 'en' : 'vi';
    
        let newPath = '';
        if (currentLang === 'VN') {
          // Switch from Vietnamese to English
          if (currentPath === '/') {
            newPath = '/en/';
          } else {
              
              if(pathEndsWithUuid(currentPath)){
                  const params = new URLSearchParams(window.location.search);
                    params.set('lang', currentLang === 'VN' ? 'en' : 'vi');
                    
                    // Nếu currentPath đã có query string sẵn thì nối thêm bằng "&"
                    if (currentPath.includes("?")) {
                    newPath = currentPath.split("?")[0] + "?" + params.toString();
                    } else {
                        newPath = currentPath + "?" + params.toString();
                    }
              }else{
                  newPath = '/en' + currentPath;
              }
              
          }
        } else {
          // Switch from English to Vietnamese
          if (currentPath.startsWith('/en/')) {
            newPath = currentPath.replace('/en/', '/');
            if (newPath === '/') {
              newPath = '/';
            }
          } else {
            newPath = currentPath.replace('/en', '');
          }
    }

        // Navigate to new URL
        window.location.href = newPath;
  }
    
    function detectLanguageFromQuery() {
        const params = new URLSearchParams(window.location.search);
        const lang = params.get('lang');
        if(lang){
            if (lang === 'en') return 'en'
            else {
                return 'vi';
            }
        }else{
            return null;
        }
    }

  // Initialize language button
  function initializeLanguageButton() {
    const currentLang = getCurrentLanguage();
    langToggle.textContent = currentLang;
    langToggle.setAttribute('data-current-lang', currentLang);

    // Update button styling based on current language
    if (currentLang === 'EN') {
      langToggle.classList.add('active');
    } else {
      langToggle.classList.remove('active');
    }
  }

  // Toggle mobile menu
  toggleButton.addEventListener('click', () => {
    mobileNav.classList.toggle('active');
    toggleButton.textContent = mobileNav.classList.contains('active') ? '✕' : '☰';
  });

  // Toggle submenu on mobile
  submenuLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault(); // Prevent navigation for parent link
      const parentLi = link.parentElement;
      const submenu = parentLi.querySelector('.nav-submenu');
      parentLi.classList.toggle('active');
      submenu.classList.toggle('active');
    });
  });

  // Close mobile menu when clicking a non-submenu link
  const menuLinks = document.querySelectorAll('.nav-mobile__menu a:not(.nav-has-submenu > a)');
  menuLinks.forEach(link => {
    link.addEventListener('click', () => {
      mobileNav.classList.remove('active');
      toggleButton.textContent = '☰';
    });
  });

  // Language toggle functionality
  if (langToggle) {
    // Initialize button on page load
    initializeLanguageButton();

    // Add click event listener
    langToggle.addEventListener('click', switchLanguage);
  }
});