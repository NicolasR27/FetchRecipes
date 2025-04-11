import SwiftUI

final class RecipeDetailCoordinator: ObservableObject {
    private let recipe: Recipe
    private let container: ServiceContainer
    private let viewModel: RecipeDetailViewModel
    
    init(recipe: Recipe, container: ServiceContainer) {
        self.recipe = recipe
        self.container = container
        self.viewModel = RecipeDetailViewModel(recipe: recipe)
    }
    
    func start() -> some View {
        RecipeDetailView(viewModel: viewModel)
    }
} 