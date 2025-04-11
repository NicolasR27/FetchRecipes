import SwiftUI

struct RecipeListView: View {
    @ObservedObject private var viewModel: RecipeListViewModel
    @Environment(\.refresh) private var refresh
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.recipes.isEmpty {
                loadingView
            } else if let error = viewModel.error as? RecipeServiceError {
                errorView(for: error)
            } else {
                mainContentView
            }
        }
        .navigationTitle("Recipes")
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer,
            prompt: Text("Search by name or cuisine")
        ) {
            searchSuggestionsView
        }
        .searchScopes($viewModel.searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.title)
                    .tag(scope)
            }
        }
        .refreshable {
            do {
                try await Task.sleep(for: .seconds(0.5))
                await viewModel.fetchRecipes()
            } catch {}
        }
        .task {
            if viewModel.recipes.isEmpty {
                await viewModel.fetchRecipes()
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .controlSize(.large)
            .tint(Theme.primaryColor)
    }
    
    private func errorView(for error: RecipeServiceError) -> some View {
        Group {
            switch error {
            case .malformedData:
                ContentUnavailableView {
                    Label("Invalid Data", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(Theme.primaryColor)
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task { await viewModel.fetchRecipes() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.primaryColor)
                }
            case .emptyData:
                ContentUnavailableView {
                    Label("No Recipes", systemImage: "fork.knife")
                        .foregroundStyle(Theme.primaryColor)
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Refresh") {
                        Task { await viewModel.fetchRecipes() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.primaryColor)
                }
            default:
                ContentUnavailableView {
                    Label("Network Error", systemImage: "wifi.slash")
                        .foregroundStyle(Theme.primaryColor)
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task { await viewModel.fetchRecipes() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.primaryColor)
                }
            }
        }
    }
    
    private var searchSuggestionsView: some View {
        ForEach(viewModel.searchSuggestions, id: \.self) { suggestion in
            Text(suggestion)
                .searchCompletion(suggestion)
        }
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        if viewModel.filteredRecipes.isEmpty {
            if viewModel.searchText.isEmpty {
                ContentUnavailableView {
                    Label("No Recipes", systemImage: "fork.knife")
                        .foregroundStyle(Theme.primaryColor)
                } description: {
                    Text("Pull to refresh to load recipes")
                }
            } else {
                ContentUnavailableView.search(text: viewModel.searchText)
            }
        } else {
            ScrollView {
                LazyVStack(spacing: Theme.Padding.large, pinnedViews: .sectionHeaders) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Section {
                            LazyVStack(spacing: Theme.Padding.medium) {
                                ForEach(viewModel.recipesByCategory[category] ?? []) { recipe in
                                    NavigationLink(value: RecipeListCoordinator.Destination.recipeDetail(recipe)) {
                                        RecipeRowView(recipe: recipe)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, Theme.Padding.large)
                        } header: {
                            CategoryHeaderView(title: category)
                        }
                    }
                }
                .padding(.vertical, Theme.Padding.large)
            }
        }
    }
}

private struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: Theme.Padding.medium) {
            recipeImage
            recipeInfo
            Spacer()
        }
        .recipeCellStyle()
    }
    
    private var recipeImage: some View {
        Group {
            if let url = recipe.photoURLSmall {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
            } else {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        Image(systemName: "fork.knife")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
            }
        }
        .frame(width: Theme.ImageSize.thumbnail, height: Theme.ImageSize.thumbnail)
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
    }
    
    private var recipeInfo: some View {
        VStack(alignment: .leading, spacing: Theme.Padding.small) {
            Text(recipe.name)
                .font(.headline)
                .lineLimit(2)
            Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

private struct CategoryHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.primary)
            Spacer()
        }
        .recipeHeaderStyle()
    }
}

#Preview {
    NavigationStack {
        RecipeListView(viewModel: RecipeListViewModel(recipeService: PreviewRecipeService()))
    }
} 