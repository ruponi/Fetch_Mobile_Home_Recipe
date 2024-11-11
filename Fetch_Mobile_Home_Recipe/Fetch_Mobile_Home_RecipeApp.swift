//
//  Fetch_Mobile_Home_RecipeApp.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/8/24.
//

import SwiftUI

@main
struct Fetch_Mobile_Home_RecipeApp: App {
    var body: some Scene {
        let apiConfig = APIConfig(baseURL: baseURL)
        let recipeService = RecipeService(apiConfig: apiConfig)
        let viewModel = RecipeViewModel(recipeService: recipeService)
        WindowGroup {
            RecipeListView(viewModel: viewModel)
                .task {
                    await viewModel.loadRecipes()
                }
        }
    }
}
