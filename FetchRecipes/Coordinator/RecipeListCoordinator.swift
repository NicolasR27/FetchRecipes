import SwiftUI

final class RecipeListCoordinator: ObservableObject {
    enum Destination: Hashable {
        case recipeDetail(Recipe)
    }
    
    private let viewModel: RecipeListViewModel
    
    init() {
        self.viewModel = RecipeListViewModel()
    }
    
    func start() -> some View {
        RecipeListView(viewModel: viewModel)
    }
} 