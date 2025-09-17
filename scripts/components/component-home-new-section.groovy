// Import thư viện Searchnews để lấy tin tức
import org.craftercms.sites.editorial.Searchnews

// Khởi tạo đối tượng Searchnews để thực hiện các thao tác tìm kiếm tin tức
def searchNews = new Searchnews(searchClient, urlTransformationService)

// Lấy 6 tin tức mới nhất
def latestNews = searchNews.getAllNews(0, 6)

// Đưa dữ liệu vào templateModel để template có thể sử dụng
templateModel.latestNews = latestNews
