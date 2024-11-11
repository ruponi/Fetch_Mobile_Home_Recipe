//
//  RecipeService.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//
import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
}

/// A service class responsible for fetching recipe data from the API.
///
/// `RecipeService` handles all network operations related to recipe data,
/// including fetching recipes from remote endpoints defined in `APIConfig`.
///
/// - Note: This class is marked as final for optimization purposes.
/// - Important: Requires a valid `APIConfig` for initialization.
final class RecipeService: RecipeServiceProtocol {
    private let apiConfig: APIConfig
    private var isRequestInProgress = false
    private var isDebouncing = false
    private var retryCount = 0
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2
    private let throttleDelay: TimeInterval = 1.0
    private let debounceDelay: TimeInterval = 0.5
    
    /// Initializes a new RecipeService instance.
    /// - Parameter apiConfig: Configuration object containing API settings and endpoints.
    init(apiConfig: APIConfig) {
        self.apiConfig = apiConfig
    }
    
    /// Asynchronously fetches a list of recipes from the remote API.
    ///
    /// This method performs a network request to retrieve recipe data and
    /// returns an array of Recipe objects.
    ///
    /// - Returns: An array of `Recipe` objects retrieved from the API.
    /// - Throws: `NetworkError` if the network request fails or data is invalid.
    ///
    /// - Note: This is an async operation and should be called from an async context.
    ///
    /// ## Example Usage:
    /// ```swift
    /// do {
    ///     let recipes = try await recipeService.fetchRecipes()
    ///     // Process recipes
    /// } catch {
    ///     // Handle error
    /// }
    /// ```
    func fetchRecipes() async throws -> [Recipe] {
        // Throttling: If a request is already in progress, return early
        guard !isRequestInProgress else {
            throw NetworkError.requestThrottled
        }
        
        // Debouncing: Delay the request to simulate debouncing behavior
        guard !isDebouncing else {
            print("Debouncing: Ignoring request, waiting for debounce delay.")
            // Just return and wait until the debounce is over
            return try await waitForDebounceAndFetch()
        }
        
        isRequestInProgress = true
        defer { isRequestInProgress = false }
        
        isDebouncing = true
        defer { isDebouncing = false }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        let session = URLSession(configuration: configuration)
        
        // Generate URL for request
        let url = RecipeEndpoints.getRecipes.url(baseURL: apiConfig.baseURL)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return try await fetchWithRetry(session: session, request: request)
    }
    
    private func fetchWithRetry(session: URLSession, request: URLRequest) async throws -> [Recipe] {
        var attempt = 0
        
        while attempt < maxRetries {
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let errorJson = String(data: data, encoding: .utf8) {
                        print("🔴 Server error response: \(errorJson)")
                    }
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
                
                // Handle successful response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("✅ Received JSON:\(jsonString)")
                }
                
                // Decode the response
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let decodedData = try decoder.decode(RecipeResponse.self, from: data)
                return decodedData.recipes
                
            } catch {
                print("🔴 Attempt \(attempt + 1) failed: \(error)")
                if attempt < maxRetries - 1 {
                    // Exponential backoff retry
                    let delay = retryDelay * pow(2.0, Double(attempt))
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
                attempt += 1
            }
        }
        
        throw NetworkError.maxRetryExceeded
    }
    
    
    // Helper function to wait for debounce and then fetch data
    private func waitForDebounceAndFetch() async throws -> [Recipe] {
        try await Task.sleep(nanoseconds: UInt64(debounceDelay * 1_000_000_000))
        return try await fetchRecipes() // Recursively call fetch after debounce time
    }
}


