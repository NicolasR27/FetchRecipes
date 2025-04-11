import Foundation

final class RecipeListViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let recipeService: RecipeService
    
    init(recipeService: RecipeService = RecipeService()) {
        self.recipeService = recipeService
    }
    
    @MainActor
    func fetchRecipes() async {
        isLoading = true
        error = nil
        
        do {
            recipes = try await recipeService.fetchRecipes()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 