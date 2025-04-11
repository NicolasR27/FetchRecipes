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
            } else if let error = viewModel.error {
                ErrorView(error: error, retryAction: { Task { await viewModel.fetchRecipes() } })
            } else if viewModel.recipes.isEmpty {
                EmptyStateView()
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

private struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text("Error loading recipes")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "list.bullet.clipboard")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No recipes available")
                .font(.headline)
            Text("Pull to refresh to try again")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        RecipeListView(viewModel: RecipeListViewModel())
    }
} 