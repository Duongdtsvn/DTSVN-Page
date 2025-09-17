// Import các thư viện cần thiết để xử lý tìm kiếm dự án và profile
import org.craftercms.sites.editorial.SearchProjects
import org.craftercms.sites.editorial.ProfileUtils

// Khởi tạo đối tượng SearchProjects để thực hiện các thao tác tìm kiếm dự án
def searchProjects = new SearchProjects(searchClient, urlTransformationService)

// Lấy tham số trang hiện tại từ URL, mặc định là trang 1 nếu không có
def page = params.page ? params.page.toInteger() : 1
// Số lượng dự án hiển thị trên mỗi trang
def itemsPerPage = 12

// Tính toán vị trí bắt đầu để lấy dữ liệu cho trang hiện tại
def start = (page - 1) * itemsPerPage

// Khởi tạo biến để lưu trữ danh sách dự án và tổng số dự án
def projectItems = []
def totalItems = 0

// Lấy tất cả dự án
projectItems = searchProjects.getAllProjects(start, itemsPerPage)
totalItems = searchProjects.getAllProjects(0, 1000).size()

// Tính toán thông tin phân trang
def totalPages = Math.ceil(totalItems / itemsPerPage).toInteger()
def hasNextPage = page < totalPages
def hasPrevPage = page > 1

// Tạo danh sách các số trang để hiển thị trong thanh phân trang
// Hiển thị tối đa 5 trang (trang hiện tại ± 2)
def pageNumbers = []
def startPage = Math.max(1, page - 2)
def endPage = Math.min(totalPages, page + 2)

// Thêm các số trang vào danh sách để hiển thị
for (int i = startPage; i <= endPage; i++) {
    pageNumbers << i
}

// Đưa tất cả dữ liệu đã xử lý vào templateModel để template có thể sử dụng
templateModel.projectItems = projectItems    // Danh sách dự án cho trang hiện tại
templateModel.totalItems = totalItems        // Tổng số dự án
templateModel.currentPage = page             // Trang hiện tại
templateModel.totalPages = totalPages        // Tổng số trang
templateModel.hasNextPage = hasNextPage      // Có trang tiếp theo không
templateModel.hasPrevPage = hasPrevPage      // Có trang trước không
templateModel.pageNumbers = pageNumbers      // Danh sách số trang để hiển thị
templateModel.itemsPerPage = itemsPerPage    // Số dự án trên mỗi trang
