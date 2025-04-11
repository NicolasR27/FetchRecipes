import Foundation
import Combine

enum SearchScope: Hashable, CaseIterable {
    case all
    case name
    case cuisine
    
    var title: String {
        switch self {
        case .all: return "All"
        case .name: return "Name"
        case .cuisine: return "Cuisine"
        }
    }
}

final class RecipeListViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var filteredRecipes: [Recipe] = []
    @Published private(set) var recipesByCategory: [String: [Recipe]] = [:]
    @Published private(set) var categories: [String] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    @Published var searchText = "" {
        didSet { filterAndUpdateCategories() }
    }
    
    @Published var searchScope = SearchScope.all {
        didSet { filterAndUpdateCategories() }
    }
    
    var searchSuggestions: [String] {
        let allSuggestions = Set(recipes.map(\.name) + recipes.map(\.cuisine))
        guard !searchText.isEmpty else { return Array(allSuggestions.prefix(5)) }
        
        return allSuggestions
            .filter { $0.localizedCaseInsensitiveContains(searchText) }
            .prefix(5)
            .sorted()
    }
    
    private let recipeService: RecipeServiceProtocol
    
    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }
    
    @MainActor
    func fetchRecipes(endpoint: RecipeEndpoint = .recipes) async {
        isLoading = true
        error = nil
        
        do {
            recipes = try await recipeService.fetchRecipes(endpoint: endpoint)
            filterAndUpdateCategories()
        } catch {
            self.error = error
            self.recipes = []
            filterAndUpdateCategories()
        }
        
        isLoading = false
    }
    
    private func filterAndUpdateCategories() {
        // Filter recipes based on search text and scope
        if searchText.isEmpty {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { recipe in
                switch searchScope {
                case .all:
                    return recipe.name.localizedCaseInsensitiveContains(searchText) ||
                           recipe.cuisine.localizedCaseInsensitiveContains(searchText)
                case .name:
                    return recipe.name.localizedCaseInsensitiveContains(searchText)
                case .cuisine:
                    return recipe.cuisine.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        // Group filtered recipes by cuisine
        recipesByCategory = Dictionary(grouping: filteredRecipes) { $0.cuisine }
        // Sort categories alphabetically
        categories = recipesByCategory.keys.sorted()
    }
}
