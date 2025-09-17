// Import các thư viện cần thiết để xử lý tìm kiếm tin tức và profile
import org.craftercms.sites.editorial.Searchnews
import org.craftercms.sites.editorial.ProfileUtils

// Lấy tham số tìm kiếm từ URL
// Hỗ trợ: title, content, category (tab), sort, page

def page = params.page ? params.page.toInteger() : 1
// Số lượng tin tức hiển thị trên mỗi trang
int itemsPerPage = 12
int start = (page - 1) * itemsPerPage

def searchParams = [:]
if (params.title?.trim()) {
    searchParams.title = params.title.trim().toLowerCase()
}
if (params.content?.trim()) {
    searchParams.content = params.content.trim().toLowerCase()
}
// category lấy từ tab
if (params.tab && params.tab != 'all') {
    searchParams.category = params.tab
}

def sort = params.sort ?: "newest"
def validSorts = ["newest", "oldest", "a_to_z", "z_to_a"]
if (!validSorts.contains(sort)) {
    sort = "newest"
}

def searchNews = new Searchnews(searchClient, urlTransformationService)
def newsItems = searchNews.searchNewsAdvanced(searchParams, start, itemsPerPage, sort, 'en')
def totalItems = searchNews.getTotalNews(searchParams, 'en')
def totalPages = Math.ceil(totalItems / itemsPerPage) as Integer
if (totalPages < 1) totalPages = 1

// Lấy danh sách các category từ contentModel để hiển thị các tab
// (giữ nguyên logic cũ)
def tabs = []
if (contentModel.list_category_o && contentModel.list_category_o.item) {
    def items = contentModel.list_category_o.item
    tabs = (items instanceof List) ? items : [items]
}

def selectedTab = params.tab ?: 'all'

templateModel.tabs = tabs
// Đưa các tham số vào templateModel để giữ lại filter khi chuyển trang
templateModel.selectedTab = selectedTab
// Đưa searchParams vào để hiển thị lại trên form
templateModel.searchParams = searchParams
// Đưa sort vào templateModel
templateModel.sort = sort
templateModel.newsItems = newsItems ?: []
templateModel.totalItems = totalItems
// Phân trang
// Tính toán thông tin phân trang
templateModel.currentPage = page
templateModel.totalPages = totalPages
templateModel.itemsPerPage = itemsPerPage
// Tạo danh sách các số trang để hiển thị trong thanh phân trang (tối đa 5 trang)
def pageNumbers = []
def startPage = Math.max(1, page - 2)
def endPage = Math.min(totalPages, page + 2)
for (int i = startPage; i <= endPage; i++) {
    pageNumbers << i
}
templateModel.pageNumbers = pageNumbers
templateModel.hasNextPage = page < totalPages
templateModel.hasPrevPage = page > 1

// Nếu đang tìm kiếm và có tab cụ thể, lọc lại kết quả để chỉ hiển thị bài viết thuộc tab đó
if ((searchParams.title || searchParams.content) && selectedTab != 'all') {
    // Lọc lại newsItems để chỉ lấy bài viết thuộc category đang chọn
    newsItems = newsItems.findAll { item ->
        item.categories && item.categories.contains(selectedTab)
    }
    // Nếu không có bài viết nào thuộc tab, trả về rỗng
    if (!newsItems || newsItems.size() == 0) {
        newsItems = []
        totalItems = 0
        totalPages = 1
    } else {
        totalItems = newsItems.size()
        totalPages = Math.ceil(totalItems / itemsPerPage) as Integer
        if (totalPages < 1) totalPages = 1
    }
}
