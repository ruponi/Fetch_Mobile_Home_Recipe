//
//  RecipeTest.swift
//  Fetch_Mobile_Home_RecipeTests
//
//  Created by Ruslan Ponomarenko on 11/8/24.
//
import Foundation
import XCTest
@testable import Fetch_Mobile_Home_Recipe

final class RecipeTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRecipeParsingFromJSON() {
        // Arrange: Get the JSON string from MockData
        let jsonData = MockData.recipeJSON.data(using: .utf8)!
        
        // Act: Decode the JSON data into a Recipe object
        let decoder = JSONDecoder()
        let parsedRecipes = try? decoder.decode([Recipe].self, from: jsonData)
        
        // Assert: Verify that the parsed recipe matches the expected data
        XCTAssertNotNil(parsedRecipes)
        let parsedRecipe = parsedRecipes?.first
        XCTAssertEqual(parsedRecipe?.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
        XCTAssertEqual(parsedRecipe?.name, "Apam Balik")
        XCTAssertEqual(parsedRecipe?.cuisine, "Malaysian")
        
        func testPerformanceExample() throws {
            // This is an example of a performance test case.
            self.measure {
                // Put the code you want to measure the time of here.
            }
        }
        
    }
}
