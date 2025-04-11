import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject private var viewModel: RecipeDetailViewModel
    
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = viewModel.recipe.photoURLLarge {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.recipe.name)
                        .font(.title)
                        .bold()
                    
                    Text(viewModel.recipe.cuisine)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                if let sourceURL = viewModel.recipe.sourceURL {
                    Link("View Original Recipe", destination: sourceURL)
                        .buttonStyle(.bordered)
                        .padding(.horizontal)
                }
                
                if let youtubeURL = viewModel.recipe.youtubeURL {
                    Link("Watch on YouTube", destination: youtubeURL)
                        .buttonStyle(.bordered)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: Recipe(
            id: UUID(),
            name: "Sample Recipe",
            cuisine: "Italian",
            photoURLSmall: URL(string: "https://example.com/small.jpg"),
            photoURLLarge: URL(string: "https://example.com/large.jpg"),
            sourceURL: URL(string: "https://example.com"),
            youtubeURL: URL(string: "https://youtube.com/watch?v=123")
        )))
    }
} 