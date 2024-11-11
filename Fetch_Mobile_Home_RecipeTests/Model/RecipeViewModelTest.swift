//
//  RecipeViewModelTest.swift
//  Fetch_Mobile_Home_RecipeTests
//
//  Created by Ruslan Ponomarenko on 11/10/24.
//
import Foundation
import XCTest
@testable import Fetch_Mobile_Home_Recipe

@MainActor
final class RecipeViewModelTests: XCTestCase {
    private var sut: RecipeViewModel!
    private var mockRecipeService: MockRecipeService!
    
    override func setUp() async throws {
        mockRecipeService = MockRecipeService()
        sut = RecipeViewModel(recipeService: mockRecipeService)
    }
    
    override func tearDown() async throws {
        sut = nil
        mockRecipeService = nil
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.selectedRecipe)
        XCTAssertEqual(sut.state, .empty)
    }
    
    // MARK: - LoadRecipes Tests
    
    func testLoadRecipes_Success() async {
        // Given
        let expectedRecipes = [MockData.recipe1, MockData.recipe2,]
        mockRecipeService.mockRecipes = expectedRecipes
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(sut.recipes, expectedRecipes)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.state, .dataAvailable(expectedRecipes))
    }
    
    func testLoadRecipes_NetworkError() async {
        // Given
        let expectedError = NetworkError.invalidResponse
        mockRecipeService.mockError = expectedError
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertEqual(sut.errorMessage, expectedError.errorDescription)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.state, .error(expectedError.errorDescription!))
    }
    
    func testLoadRecipes_UnexpectedError() async {
        // Given
        let unexpectedError = NSError(domain: "test", code: -1)
        mockRecipeService.mockError = unexpectedError
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertEqual(sut.errorMessage, "Unexpected error: \(unexpectedError.localizedDescription)")
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.state, .error("Unexpected error: \(unexpectedError.localizedDescription)"))
    }
    
    // MARK: - State Tests
    
    func testState_Loading() {
        // Given
        sut.isLoading = true
        
        // Then
        XCTAssertEqual(sut.state, .loading)
    }
    
    func testState_Error() {
        // Given
        let errorMessage = "Test error"
        sut.errorMessage = errorMessage
        
        // Then
        XCTAssertEqual(sut.state, .error(errorMessage))
    }
    
    func testState_Empty() {
        // Given
        sut.recipes = []
        
        // Then
        XCTAssertEqual(sut.state, .empty)
    }
    
    func testState_DataAvailable() {
        // Given
        let recipes = [MockData.recipe1]
        sut.recipes = recipes
        
        // Then
        XCTAssertEqual(sut.state, .dataAvailable(recipes))
    }
}

extension RecipeListViewState: @retroactive Equatable {
    public static func == (lhs: RecipeListViewState, rhs: RecipeListViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        case (.empty, .empty):
            return true
        case (.dataAvailable(let lhsRecipes), .dataAvailable(let rhsRecipes)):
            return lhsRecipes == rhsRecipes
        default:
            return false
        }
    }
}
