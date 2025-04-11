import Foundation

final class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }
} 
