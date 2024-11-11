//
//  Endpoints.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//
import Foundation

//Generally we can setup different baseURLs for different application Schemes: Dev, stage, product ets.
var baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"

struct APIConfig {
    let baseURL: String
}

/// Endpoints for recipe Data
enum RecipeEndpoints {
    /// Get all recipes
    case getRecipes
    /// Get Empty Recipes
    case getEmptyRecipes
    /// Get Malformed Data
    case getMalformedRecipes
    
    var path: String {
        switch self {
        case .getRecipes: return "/recipes.json"
        case .getEmptyRecipes: return "/recipes-empty.json"
        case .getMalformedRecipes: return "/recipes-malformed.json"
        }
    }
    
    func url(baseURL: String) -> URL {
        return URL(string: baseURL + path)!
    }
}
