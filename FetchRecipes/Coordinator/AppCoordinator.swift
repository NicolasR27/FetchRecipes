import SwiftUI

final class AppCoordinator: ObservableObject {
    private let container: ServiceContainer
    
    init(container: ServiceContainer) {
        self.container = container
    }
    
    func start() -> some View {
        AppCoordinatorView()
            .environmentObject(container)
    }
}

private struct AppCoordinatorView: View {
    @State private var navigationPath = NavigationPath()
    @EnvironmentObject private var container: ServiceContainer

    var body: some View {
        NavigationStack(path: $navigationPath) {
            RecipeListCoordinator(container: container).start()
                .navigationDestination(for: RecipeListCoordinator.Destination.self) { destination in
                    switch destination {
                    case .recipeDetail(let recipe):
                        RecipeDetailCoordinator(recipe: recipe, container: container).start()
                    }
                }
        }
    }
}
