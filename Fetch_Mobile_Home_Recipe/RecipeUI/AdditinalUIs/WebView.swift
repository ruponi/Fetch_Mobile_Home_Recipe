//
//  WebView.swift
//  Fetch_Mobile_Home_Recipe
//
//  Created by Ruslan Ponomarenko on 11/9/24.
//


import WebKit
import SwiftUI

struct WebView: View {
    let url: URL
    let title: String

    var body: some View {
        VStack {
            WebViewRepresentable(url: url)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct WebViewRepresentable: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
            
        }
    }
}
