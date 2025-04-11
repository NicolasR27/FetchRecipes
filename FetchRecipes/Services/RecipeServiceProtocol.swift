import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes(endpoint: RecipeEndpoint) async throws -> [Recipe]
} 