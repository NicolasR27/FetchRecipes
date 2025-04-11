import Foundation

struct Recipe: Identifiable, Hashable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    init(id: UUID, name: String, cuisine: String, photoURLSmall: URL? = nil, photoURLLarge: URL? = nil, sourceURL: URL? = nil, youtubeURL: URL? = nil) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.photoURLSmall = photoURLSmall
        self.photoURLLarge = photoURLLarge
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }
}

extension Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        
        if let smallURLString = try container.decodeIfPresent(String.self, forKey: .photoURLSmall) {
            photoURLSmall = URL(string: smallURLString)
        } else {
            photoURLSmall = nil
        }
        
        if let largeURLString = try container.decodeIfPresent(String.self, forKey: .photoURLLarge) {
            photoURLLarge = URL(string: largeURLString)
        } else {
            photoURLLarge = nil
        }
        
        if let sourceURLString = try container.decodeIfPresent(String.self, forKey: .sourceURL) {
            sourceURL = URL(string: sourceURLString)
        } else {
            sourceURL = nil
        }
        
        if let youtubeURLString = try container.decodeIfPresent(String.self, forKey: .youtubeURL) {
            youtubeURL = URL(string: youtubeURLString)
        } else {
            youtubeURL = nil
        }
    }
} 