/**
 * Component chuyển đổi ngôn ngữ
 * Xử lý chức năng chuyển đổi ngôn ngữ với hiệu ứng mượt mà
 * Hỗ trợ cả Component-Header.ftl và Item.ftl
 */
class LanguageSwitcher {
    constructor() {
        // Tìm tất cả các nút chuyển đổi ngôn ngữ trên trang
        this.langButtons = document.querySelectorAll('.lang-btn');
        // Lấy ngôn ngữ từ query string ?lang=en hoặc ?lang=vi, mặc định 'vi'
        this.currentLang = this.detectLanguageFromQuery();
        // Khởi tạo component
        this.init();
    }

    detectLanguageFromQuery() {
        const params = new URLSearchParams(window.location.search);
        const lang = params.get('lang');
        if (lang === 'en') return 'en';
        return 'vi';
    }

    updateUrlForLanguage(lang) {
        const url = new URL(window.location.href);
        if (lang === 'en') {
            url.searchParams.set('lang', 'en');
        } else {
            url.searchParams.delete('lang');
        }
        window.history.replaceState({}, '', url.toString());
    }

    init() {
        // Kiểm tra xem có tìm thấy nút chuyển đổi ngôn ngữ không
        if (this.langButtons.length === 0) {
            console.warn('Không tìm thấy nút chuyển đổi ngôn ngữ');
            return;
        }

        // Khởi tạo ngôn ngữ ban đầu ngay lập tức
        this.initializeLanguage();

        // Thiết lập các sự kiện cho nút
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Duyệt qua từng nút chuyển đổi ngôn ngữ
        this.langButtons.forEach(button => {
            // Sự kiện click chuột
            button.addEventListener('click', (e) => {
                e.preventDefault(); // Ngăn chặn hành vi mặc định
                this.handleLanguageSwitch(button);
            });

            // Điều hướng bằng bàn phím (Enter hoặc Space)
            button.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    this.handleLanguageSwitch(button);
                }
            });

            // Quản lý focus cho accessibility
            button.addEventListener('focus', () => {
                button.setAttribute('aria-pressed', 'true');
            });
        });
    }

    handleLanguageSwitch(clickedButton) {
        // Xác định ngôn ngữ mới dựa trên text hiện tại của nút
        const currentButtonText = clickedButton.textContent;
        const newLang = currentButtonText === 'VN' ? 'en' : 'vi';

        // Nếu đã ở ngôn ngữ này rồi thì không làm gì
        if (newLang === this.currentLang) {
            return;
        }

        // Cập nhật trạng thái các nút
        this.updateButtonStates(clickedButton, newLang);

        // Chuyển đổi nội dung
        this.switchContent(newLang);

        // Cập nhật ngôn ngữ hiện tại
        this.currentLang = newLang;

        // Cập nhật tiêu đề trang
        this.updatePageTitle(newLang);

        // Cập nhật URL khi chuyển ngôn ngữ
        this.updateUrlForLanguage(newLang);

        // Phát sự kiện tùy chỉnh cho các component khác
        this.dispatchLanguageChangeEvent(newLang);
    }

    updateButtonStates(activeButton, newLang) {
        // Loại bỏ trạng thái active khỏi tất cả các nút
        this.langButtons.forEach(btn => {
            btn.classList.remove('active');
            btn.setAttribute('aria-pressed', 'false');
        });

        // Thêm trạng thái active cho nút được click
        activeButton.classList.add('active');
        activeButton.setAttribute('aria-pressed', 'true');

        // Cập nhật text của tất cả các nút để đồng bộ
        this.langButtons.forEach(btn => {
            btn.textContent = newLang === 'en' ? 'EN' : 'VN';
            btn.setAttribute('data-current-lang', newLang === 'en' ? 'EN' : 'VN');
        });
    }

    switchContent(lang) {
        // Tìm tất cả các phần tử có thuộc tính data-lang
        const elements = document.querySelectorAll('[data-lang]');

        elements.forEach(element => {
            const elementLang = element.getAttribute('data-lang');

            if (elementLang === lang) {
                // Hiển thị phần tử với hiệu ứng fade-in
                this.showElement(element);
            } else {
                // Ẩn phần tử với hiệu ứng fade-out
                this.hideElement(element);
            }
        });
    }

    showElement(element) {
    element.style.opacity = '0';

    // Kiểm tra nếu là breadcrumb thì set display = flex
    if (element.classList.contains('sec-pageTitle__breadcrumb')) {
        element.style.display = 'flex';
    } else {
        element.style.display = 'block';
    }

    // Force reflow để đảm bảo transition hoạt động
    element.offsetHeight;

    element.style.opacity = '1';
    element.classList.add('fade-in');
    element.classList.remove('fade-out');
}


    hideElement(element) {
        // Ẩn phần tử với opacity = 0
        element.style.opacity = '0';
        element.classList.add('fade-out');
        element.classList.remove('fade-in');

        // Sau 300ms thì ẩn hoàn toàn phần tử
        setTimeout(() => {
            element.style.display = 'none';
        }, 300);
    }

    updatePageTitle(lang) {
        // Định nghĩa tiêu đề trang cho từng ngôn ngữ
        const titles = {
            'vi': 'Tin tức - DTSVN',
            'en': 'News - DTSVN'
        };

        // Cập nhật tiêu đề trang
        document.title = titles[lang] || document.title;
    }

    dispatchLanguageChangeEvent(lang) {
        // Tạo sự kiện tùy chỉnh để thông báo cho các component khác
        const event = new CustomEvent('languageChanged', {
            detail: { language: lang },
            bubbles: true
        });
        document.dispatchEvent(event);
    }

    initializeLanguage() {
        // Cập nhật text và trạng thái của tất cả các nút ngay lập tức
        this.langButtons.forEach(btn => {
            const buttonText = this.currentLang === 'en' ? 'EN' : 'VN';
            btn.textContent = buttonText;
            btn.setAttribute('data-current-lang', buttonText);

            if (this.currentLang === 'en') {
                btn.classList.add('active');
                btn.setAttribute('aria-pressed', 'true');
            } else {
                btn.classList.remove('active');
                btn.setAttribute('aria-pressed', 'false');
            }
        });

        // Thiết lập ngôn ngữ ban đầu cho nội dung
        this.switchContent(this.currentLang);

        // Đảm bảo URL đúng với ngôn ngữ hiện tại khi load trang
        this.updateUrlForLanguage(this.currentLang);
    }

    // Phương thức public để lấy ngôn ngữ hiện tại
    getCurrentLanguage() {
        return this.currentLang;
    }

    // Phương thức public để chuyển đổi ngôn ngữ bằng code
    switchToLanguage(lang) {
        // Tìm nút tương ứng với ngôn ngữ
        const button = Array.from(this.langButtons).find(btn => {
            const buttonLang = btn.textContent === 'VN' ? 'vi' : 'en';
            return buttonLang === lang;
        });

        if (button) {
            this.handleLanguageSwitch(button);
        }
    }
}

// Khởi tạo ngay khi DOM sẵn sàng
document.addEventListener('DOMContentLoaded', function () {
    // Khởi tạo language switcher và lưu vào window object
    window.languageSwitcher = new LanguageSwitcher();

    // Thêm listener toàn cục cho sự kiện thay đổi ngôn ngữ
    document.addEventListener('languageChanged', function (e) {
        console.log('Đã chuyển đổi ngôn ngữ sang:', e.detail.language);

        // Có thể thêm logic bổ sung ở đây cho các component khác
        // cần phản ứng với việc thay đổi ngôn ngữ
    });
});

// Export cho các hệ thống module
if (typeof module !== 'undefined' && module.exports) {
    module.exports = LanguageSwitcher;
}