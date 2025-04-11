import SwiftUI

final class AppCoordinator: ObservableObject {
    func start() -> some View {
        AppCoordinatorView()
    }
}

private struct AppCoordinatorView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            RecipeListCoordinator().start()
                .navigationDestination(for: RecipeListCoordinator.Destination.self) { destination in
                    switch destination {
                        case .recipeDetail(let recipe):
                            RecipeDetailCoordinator(recipe: recipe).start()
                    }
                }
        }
    }
}
