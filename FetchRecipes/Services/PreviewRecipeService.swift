import Foundation

actor PreviewRecipeService: RecipeServiceProtocol {
    func fetchRecipes(endpoint: RecipeEndpoint) async throws -> [Recipe] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch endpoint {
        case .recipes:
            return [
                Recipe(id: UUID(), name: "Pasta Carbonara", cuisine: "Italian"),
                Recipe(id: UUID(), name: "Sushi Roll", cuisine: "Japanese"),
                Recipe(id: UUID(), name: "Tacos", cuisine: "Mexican")
            ]
        case .malformedData:
            throw RecipeServiceError.malformedData
        case .emptyData:
            throw RecipeServiceError.emptyData
        }
    }
} 