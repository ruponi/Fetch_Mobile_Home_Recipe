//
//  RecipeViewModel.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//

import Combine


enum RecipeListViewState {
    case loading
    case error(String)
    case empty
    case dataAvailable([Recipe])
}

// Protocol defining the interface for a Recipe view model.
///
/// This protocol defines the required properties and methods for managing recipe data
/// and UI state in a SwiftUI view. It inherits from `ObservableObject` to support
/// SwiftUI's data binding.
///
/// - Note: All implementations must be marked with `@MainActor` for thread safety.
@MainActor
protocol RecipeViewModelProtocol: ObservableObject {
    /// Array of Recipe objects currently loaded in the view model.
      var recipes: [Recipe] { get set }
      
      /// Optional error message to display when an error occurs.
      var errorMessage: String? { get set }
      
      /// Boolean flag indicating whether data is currently being loaded.
      var isLoading: Bool { get set }
      
      /// The current state of the recipe list view.
      var state: RecipeListViewState { get }
      
      /// Currently selected recipe for detail view or actions.
      var selectedRecipe: Recipe? { get set }
      
      /// Asynchronously loads recipes from the data source.
      func loadRecipes() async
}

/// View model responsible for managing recipe data and UI state.
///
/// This class handles the business logic for the recipe list view, including:
/// - Loading recipes from a service
/// - Managing loading states
/// - Handling errors
/// - Maintaining selected recipe state
///
/// - Note: Marked with `@MainActor` to ensure all UI updates occur on the main thread.
@MainActor
class RecipeViewModel: ObservableObject, RecipeViewModelProtocol {
    /// Published property containing the current list of recipes.
    @Published var recipes: [Recipe] = []
    
    /// Published property containing the current error message, if any.
    @Published var errorMessage: String? = nil
    
    /// Published property indicating whether data is being loaded.
    @Published var isLoading: Bool = false
    
    /// Published property containing the currently selected recipe.
    @Published var selectedRecipe: Recipe? = nil
    
    /// Computed property that determines the current view state based on model properties.
    /// - Returns: A `RecipeListViewState` value representing the current UI state.
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
    
    private let recipeService: RecipeServiceProtocol
    
    /// Initializes a new RecipeViewModel instance.
    /// - Parameter recipeService: The service used to fetch recipe data.
    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }
    
    /// Asynchronously loads recipes from the recipe service.
    ///
    /// This method updates the loading state and handles any errors that occur
    /// during the loading process.
    ///
    /// - Note: This method is automatically executed on the main thread due to @MainActor.
    func loadRecipes() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            recipes = try await recipeService.fetchRecipes()
            errorMessage = nil
        } catch let error as NetworkError {
            recipes = []
            // We shows the real error descrition but for product environment we will show something neutral :)
            errorMessage = error.errorDescription
        } catch {
            recipes = []
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }
}
