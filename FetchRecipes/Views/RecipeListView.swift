import SwiftUI

struct RecipeListView: View {
    @ObservedObject private var viewModel: RecipeListViewModel
    @Environment(\.refresh) private var refresh
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error as? RecipeServiceError {
                switch error {
                case .malformedData:
                    ContentUnavailableView {
                        Label("Invalid Data", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text("The recipe data appears to be invalid or corrupted.")
                    } actions: {
                        Button("Try Again") {
                            Task { await viewModel.fetchRecipes() }
                        }
                    }
                case .emptyData:
                    ContentUnavailableView {
                        Label("No Recipes", systemImage: "fork.knife")
                    } description: {
                        Text("There are no recipes available at the moment.")
                    } actions: {
                        Button("Refresh") {
                            Task { await viewModel.fetchRecipes() }
                        }
                    }
                default:
                    ContentUnavailableView {
                        Label("Network Error", systemImage: "wifi.slash")
                    } description: {
                        Text(error.localizedDescription)
                    } actions: {
                        Button("Try Again") {
                            Task { await viewModel.fetchRecipes() }
                        }
                    }
                }
            } else if viewModel.recipes.isEmpty {
                ContentUnavailableView {
                    Label("No Recipes", systemImage: "fork.knife")
                } description: {
                    Text("Pull to refresh to load recipes")
                }
            } else {
                List(viewModel.recipes) { recipe in
                    NavigationLink(value: RecipeListCoordinator.Destination.recipeDetail(recipe)) {
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
        }
        .navigationTitle("Recipes")
        .refreshable {
            await viewModel.fetchRecipes()
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

private struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            if let url = recipe.photoURLSmall {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        RecipeListView(viewModel: RecipeListViewModel())
    }
} 