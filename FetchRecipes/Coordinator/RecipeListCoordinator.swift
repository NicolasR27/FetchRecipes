import SwiftUI

final class RecipeListCoordinator: ObservableObject {
    enum Destination: Hashable {
        case recipeDetail(Recipe)
    }
    
    private let container: ServiceContainer
    private let viewModel: RecipeListViewModel
    
    init(container: ServiceContainer) {
        self.container = container
        self.viewModel = RecipeListViewModel(recipeService: container.recipeService)
    }
    
    func start() -> some View {
        RecipeListView(viewModel: viewModel)
    }
}
