import Foundation

enum RecipeServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

actor RecipeService {
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)/recipes.json") else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return response.recipes
        } catch let error as DecodingError {
            throw RecipeServiceError.decodingError(error)
        } catch {
            throw RecipeServiceError.networkError(error)
        }
    }
}

private struct RecipeResponse: Decodable {
    let recipes: [Recipe]
} 