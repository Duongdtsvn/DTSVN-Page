import org.craftercms.sites.editorial.RecruitmentSearchHelper

try {
    // Get pagination parameters from request
    def start = (params.page ? (params.page as Integer - 1) * 2 : 0) // 2 items per page
    def rows = 2 // Items per page

    // Get search parameters and clean them - convert to lowercase for case-insensitive search
    def searchParams = [:]
    if (params.title?.trim()) {
        searchParams.title = params.title.trim().toLowerCase()
    }
    if (params.location?.trim()) {
        searchParams.location = params.location.trim().toLowerCase()
    }
    if (params.quantity?.trim()) {
        try {
            searchParams.quantity = params.quantity.trim() as Integer
        } catch (Exception e) {
            // Ignore invalid quantity
        }
    }
    if (params.deadline?.trim()) {
        searchParams.deadline = params.deadline.trim().toLowerCase()
    }

    // Get sort parameter with validation
    def sort = params.sort ?: "newest"
    def validSorts = ["newest", "oldest", "a_to_z", "z_to_a"]
    if (!validSorts.contains(sort)) {
        sort = "newest"
    }

    // Create helper and get paginated results using advanced search
    def recruitmentHelper = new RecruitmentSearchHelper(searchClient, urlTransformationService)
    
    // Use advanced search method for better fuzzy matching and case-insensitive search
    def recruitments = recruitmentHelper.searchRecruitmentsAdvanced(searchParams, start, rows, sort)

    // Calculate total pages
    def totalItems = recruitmentHelper.getTotalRecruitments(searchParams)
    def totalPages = Math.ceil(totalItems / rows) as Integer
    if (totalPages < 1) totalPages = 1

    // Add results to template model
    templateModel.recruitments = recruitments ?: []
    templateModel.currentPage = (start / rows) + 1
    templateModel.totalPages = totalPages
    templateModel.searchParams = searchParams
    templateModel.sort = sort
    templateModel.params = params // Add params to template model

} catch (Exception e) {
    // Handle any errors gracefully
    templateModel.recruitments = []
    templateModel.currentPage = 1
    templateModel.totalPages = 1
    templateModel.searchParams = [:]
    templateModel.sort = "newest"
    templateModel.params = params
}
