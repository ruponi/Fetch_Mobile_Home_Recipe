//
//  MockRecipViewModek.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//
import Combine

class MockRecipeViewModel: RecipeViewModelProtocol {
    @Published var selectedRecipe: Recipe?
    @Published var recipes: [Recipe]
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    var state: RecipeListViewState {
        if isLoading {
            return .loading
        } else if let error = errorMessage {
            return .error(error)
        } else if recipes.isEmpty {
            return .empty
        } else {
            return .dataAvailable(recipes)
        }
    }
    
    init(recipes: [Recipe] = [MockData.recipe1,MockData.recipe2], errorMessage: String? = nil, isLoading: Bool = false) {
        self.recipes = recipes
        self.errorMessage = errorMessage
        self.isLoading = isLoading
    }
    
    func loadRecipes() {
        // This can be left empty or populated with mock behavior
    }
}
