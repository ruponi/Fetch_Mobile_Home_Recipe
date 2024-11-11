//
//  RecipRow.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//

import SwiftUI

/// Row For the recipe list
struct RecipeRow: View {
    let recipe: Recipe
    var showPhotoAction: () -> Void
    var showWebViewAction: () -> Void
    
    private enum Constants {
            static let imageHeight: CGFloat = 100
            static let cornerRadius: CGFloat = 8
            static let spacing: CGFloat = 8
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.spacing) {
                infoSection
                photoSection
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        
        private var infoSection: some View {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(recipe.name)
                        .font(.headline)
                    
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture{
                showWebViewAction()
            }
        }
        
        @ViewBuilder
        private var photoSection: some View {
            if let photoURL = recipe.photoURLSmallAsURL {
                CachedAsyncImage(url: photoURL,
                               contentMode: .fill,
                               showLoader: true)
                    .scaledToFill()
                    .frame(height: Constants.imageHeight)
                    .clipped()
                    .cornerRadius(Constants.cornerRadius)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: showPhotoAction)
            }
        }
}

//MARK: Preview provider for RecipeRow
struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(recipe: MockData.recipe1 ) {
            
        } showWebViewAction: {
            
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
