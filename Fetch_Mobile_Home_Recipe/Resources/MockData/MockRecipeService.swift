//
//  MockRecipeService.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/10/24.
//


// MARK: - Mock Recipe Service

final class MockRecipeService: RecipeServiceProtocol {
    var mockRecipes: [Recipe]?
    var mockError: Error?
    
    func fetchRecipes() async throws -> [Recipe] {
        if let error = mockError {
            throw error
        }
        return mockRecipes ?? []
    }
}