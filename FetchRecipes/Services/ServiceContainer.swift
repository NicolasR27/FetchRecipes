import Foundation

final class ServiceContainer: ObservableObject {
    @Published var recipeService: RecipeServiceProtocol
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
}

extension ServiceContainer {
    static var preview: ServiceContainer {
        ServiceContainer(recipeService: PreviewRecipeService())
    }
} 