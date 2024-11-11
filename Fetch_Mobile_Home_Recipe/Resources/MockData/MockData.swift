//
//  MockData.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/8/24.
//

import Foundation

// MockData will only be available in the test target
//#if TEST_ENVIRONMENT
struct MockData {
    static let recipe1: Recipe = {
        return Recipe(
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        )
    }()
    
    static let recipe2: Recipe = {
        return Recipe(
            id: "599344f4-3c5c-4cca-b914-2210e3b3312f",
            cuisine: "British",
            name: "Apple & Blackberry Crumble",
            photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            youtubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        )
    }()
    
    // JSON string can also be used
    static let recipeJSON: String = """
        [{ "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg" },
 {
            "cuisine": "British",
            "name": "Apple & Blackberry Crumble",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
            "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
 }] 
"""
}
//#endif
