//
//  CachedAsyncImage.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//
import SwiftUI
import Kingfisher

public struct CachedAsyncImage: View {
    
    enum ImageState {
        case progress
        case placeholder
        case loaded
    }
    
    public struct Configuration {
        
        let fadeDuration: TimeInterval
        let cache: ImageCache
        
        public init(
            fadeDuration: TimeInterval = 0.25,
            cache: ImageCache
        ) {
            self.fadeDuration = fadeDuration
            self.cache = cache
        }
    }
    
    private static var configuration: Configuration?
    
    private var url: URL?
    private let contentMode: SwiftUI.ContentMode
    private var placeholder: Image
    
    @State private var state: ImageState
    
    public init(
        url: URL?,
        contentMode: SwiftUI.ContentMode = .fit,
        showLoader: Bool = false,
        placeholder: Image = Image(systemName: "photo")
    ) {
        self.url = url
        self.contentMode = contentMode
        state = showLoader ? .progress : .placeholder
        self.placeholder = placeholder
    }
    
    public var body: some View {
        KFImage(url)
            .onFailure { _ in
                state = .placeholder
            }
            .onSuccess { _ in
                           state = .loaded
                       }
            .placeholder { _ in
                switch state {
                case .progress:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                case .placeholder:
                    placeholder
                        .resizable()
                case .loaded:
                    
                    Color.clear
                    
                }
            }
            .targetCache(.default)
            .cacheMemoryOnly()
            .fade(duration: Self.configuration?.fadeDuration ?? .zero)
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

