import org.craftercms.sites.editorial.SearchRecruitments

def searchRecruitments = new SearchRecruitments(elasticsearch, urlTransformationService)

// Lấy trang hiện tại từ tham số URL, mặc định là trang 1
def page = params.page ? params.page.toInteger() : 1

// Số lượng tin tuyển dụng trên mỗi trang
def itemsPerPage = 10
def start = (page - 1) * itemsPerPage

// Khởi tạo biến để lưu trữ danh sách tin tuyển dụng và tổng số tin
def recruitmentItems = []
def totalItems = 0

// Lấy tất cả tin tuyển dụng
recruitmentItems = searchRecruitments.getAllRecruitments(start, itemsPerPage)
totalItems = searchRecruitments.getAllRecruitments(0, 1000).size()

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
templateModel.recruitmentItems = recruitmentItems    // Danh sách tin tuyển dụng cho trang hiện tại
templateModel.totalItems = totalItems               // Tổng số tin tuyển dụng
templateModel.currentPage = page                    // Trang hiện tại
templateModel.totalPages = totalPages               // Tổng số trang
templateModel.hasNextPage = hasNextPage             // Có trang tiếp theo không
templateModel.hasPrevPage = hasPrevPage             // Có trang trước không
templateModel.pageNumbers = pageNumbers             // Danh sách số trang để hiển thị
templateModel.itemsPerPage = itemsPerPage           // Số tin tuyển dụng trên mỗi trang