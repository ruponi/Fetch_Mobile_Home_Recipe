//
//  RecipeListView.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//

import SwiftUI

/// RecipeListView
struct RecipeListView<ViewModel: RecipeViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    @State private var showPhoto = false
    @State private var showSource = false
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Recipes")
                .navigationDestination(isPresented: $showSource) {
                    if let recipe = viewModel.selectedRecipe, let webURL = recipe.sourceURLAsURL {
                        WebView(url: webURL,title: recipe.name)
                    } else {
                        Text("No web content available.")
                    }
                }
        }
    }
    
    /// Content View . Contain the main logic of the Receip List
    @ViewBuilder
    private var contentView: some View {
        List {
            switch viewModel.state {
            case .loading:
                centeredListRow {
                    progressView
                }
            case .error(let errorMessage):
                centeredListRow {
                    errorView(message: errorMessage)
                }
            case .empty:
                centeredListRow {
                    emptyView
                }
            case .dataAvailable(let recipes):
                ForEach(recipes) { recipe in
                    RecipeRow(recipe: recipe)   {
                        viewModel.selectedRecipe = recipe
                        showPhoto.toggle()
                    }
                    showWebViewAction: {
                        viewModel.selectedRecipe = recipe
                        showSource.toggle()
                    }
                }
                .sheet(isPresented: $showPhoto) {
                    if let recipe = viewModel.selectedRecipe, let largePhotoURL = recipe.photoURLLargeAsURL {
                        ImageView(url: largePhotoURL)
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            }
        }
        .refreshable {
            await viewModel.loadRecipes()
        }
        
    }
    
    @ViewBuilder
    private var progressView: some View {
        ZStack(alignment: .center) {
            ProgressView("Loading recipes...")
        }
    }
    
    @ViewBuilder
    private var emptyView: some View {
        ZStack(alignment: .center) {
            Text("No recipes available.")
                .foregroundColor(.gray)
                .padding(20)
            
        }
        
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        ZStack(alignment: .center) {
            Text(message)
                .foregroundColor(.red)
                .padding()
        }
    }
    
    @ViewBuilder
    private func centeredListRow<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.white)
            .frame(minHeight: 100)
    }
}


// Preview provider for RecipeListView
struct RecipeListView_Previews: PreviewProvider {
    
    static var previews: some View {
        RecipeListView(viewModel: MockRecipeViewModel())
    }
}
