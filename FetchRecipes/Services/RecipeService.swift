import Foundation

enum RecipeServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case malformedData
    case emptyData
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "Invalid URL"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .decodingError(let error):
                return "Data error: \(error.localizedDescription)"
            case .malformedData:
                return "The recipe data appears to be invalid"
            case .emptyData:
                return "No recipes available"
        }
    }
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

actor RecipeService: RecipeServiceProtocol {
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
        print("RecipeService initialized")
    }
    
    func fetchRecipes(endpoint: RecipeEndpoint = .recipes) async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)\(endpoint.path)") else {
            print("❌ Invalid URL: \(baseURL)\(endpoint.path)")
            throw RecipeServiceError.invalidURL
        }
        
        print("📡 Fetching recipes from: \(url)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw RecipeServiceError.networkError(NSError(domain: "", code: -1))
            }
            
            print("📥 Received response with status code: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                print("❌ Bad status code: \(httpResponse.statusCode)")
                throw RecipeServiceError.networkError(NSError(domain: "", code: httpResponse.statusCode))
            }
            
            print("🔍 Decoding response data...")
            let decodedResponse = try decoder.decode(RecipeResponse.self, from: data)
            
            if decodedResponse.recipes.isEmpty {
                print("⚠️ No recipes found in response")
                throw RecipeServiceError.emptyData
            }
            
            print("✅ Successfully decoded \(decodedResponse.recipes.count) recipes")
            
            // Validate required fields for each recipe
            for recipe in decodedResponse.recipes {
                guard !recipe.name.isEmpty, !recipe.cuisine.isEmpty else {
                    print("❌ Found recipe with empty required fields")
                    throw RecipeServiceError.malformedData
                }
            }
            
            return decodedResponse.recipes
        } catch let error as DecodingError {
            print("❌ Decoding error: \(error)")
            throw RecipeServiceError.malformedData
        } catch let error as RecipeServiceError {
            print("❌ Service error: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Network error: \(error.localizedDescription)")
            throw RecipeServiceError.networkError(error)
        }
    }
}

private struct RecipeResponse: Decodable {
    let recipes: [Recipe]
} 
