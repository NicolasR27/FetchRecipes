import Foundation

enum RecipeServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case malformedData
    case emptyData
}

enum RecipeEndpoint {
    case recipes
    case malformedData
    case emptyData
    
    var path: String {
        switch self {
        case .recipes:
            return "/recipes.json"
        case .malformedData:
            return "/recipes-malformed.json"
        case .emptyData:
            return "/recipes-empty.json"
        }
    }
}

actor RecipeService {
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecipes(endpoint: RecipeEndpoint = .recipes) async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)\(endpoint.path)") else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
            
            // Handle empty data case
            if response.recipes.isEmpty {
                throw RecipeServiceError.emptyData
            }
            
            // Validate required fields for each recipe
            for recipe in response.recipes {
                guard !recipe.name.isEmpty, !recipe.cuisine.isEmpty else {
                    throw RecipeServiceError.malformedData
                }
            }
            
            return response.recipes
        } catch let error as DecodingError {
            throw RecipeServiceError.malformedData
        } catch let error as RecipeServiceError {
            throw error
        } catch {
            throw RecipeServiceError.networkError(error)
        }
    }
}

private struct RecipeResponse: Decodable {
    let recipes: [Recipe]
} 