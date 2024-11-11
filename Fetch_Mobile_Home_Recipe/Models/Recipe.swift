//
//  Recipe.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/8/24.
//
import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
   let recipes: [Recipe]
}

/// `Recipe` is a model representing a cooking recipe with essential information like name, cuisine type, photos, and optional external links.
struct Recipe: Identifiable, Codable {
    // Required properties
    
    /// Unique identifier for each recipe
    let id: String
    
    /// Cuisine type of the recipe
    let cuisine: String
    
    /// Name of the recipe
    let name: String
    
    // Optional properties
    
    /// URL for full-size photo, optional
    let photoURLLarge: String?
    
    /// URL for small photo, optional for list view
    let photoURLSmall: String?
    
    /// URL of the original website for the recipe, optional
    let sourceURL: String?
    
    /// URL of the YouTube video for the recipe, optional
    let youtubeURL: String?
    
    // Custom coding keys to match API field names
    //(Sure, we can use just default key decoding startegy like SnakCase, but I prefer to control it)
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    
    // Computed property to convert photoURLSmall to URL
    var photoURLSmallAsURL: URL? {
        guard let urlString = photoURLSmall else { return nil }
        return URL(string: urlString)
    }
    
    var photoURLLargeAsURL: URL? {
        guard let urlString = photoURLLarge else { return nil }
        return URL(string: urlString)
    }
    
    var sourceURLAsURL: URL? {
        guard let urlString = sourceURL else { return nil }
        return URL(string: urlString)
    }
    
}

// MARK: - Additional confirmation
extension Recipe: Hashable {
   static func == (lhs: Recipe, rhs: Recipe) -> Bool {
       lhs.id == rhs.id
   }
   
   func hash(into hasher: inout Hasher) {
       hasher.combine(id)
   }
}

