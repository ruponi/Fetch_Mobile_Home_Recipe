//
//  ImageView.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/10/24.
//

import Foundation
import SwiftUI

// ImageView to display large image in a sheet
struct ImageView: View {
    let url: URL?
    
    var body: some View {
        VStack {
            if let url = url {
                CachedAsyncImage(url: url,  contentMode: .fill,
                                 showLoader: true)
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(0)
                .edgesIgnoringSafeArea(.all)
            } else {
                Text("No image available")
            }
        }
    }
}
