import SwiftUI

final class RecipeDetailCoordinator: ObservableObject {
    private let recipe: Recipe
    private let viewModel: RecipeDetailViewModel
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.viewModel = RecipeDetailViewModel(recipe: recipe)
    }
    
    func start() -> some View {
        RecipeDetailView(viewModel: viewModel)
    }
} 