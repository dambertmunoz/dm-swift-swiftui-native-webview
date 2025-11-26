//
//  SimpleWebViewDemo.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI

/// Most basic WebView usage - just a URL
struct SimpleWebViewDemo: View {
    var body: some View {
        WebView(url: URL(string: "https://developer.apple.com/swift/")!)
            .navigationTitle("Simple WebView")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - WebView Placeholder for iOS < 26
// Remove this when compiling for iOS 26+

struct WebView: View {
    let url: URL
    @Binding var state: WebViewState?
    
    init(url: URL, state: Binding<WebViewState?> = .constant(nil)) {
        self.url = url
        self._state = state
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text("WebView Placeholder")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("URL: \(url.absoluteString)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Native WebView requires iOS 26+")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

struct WebViewState {
    var isLoading: Bool = false
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    var title: String? = nil
    var currentURL: URL? = nil
    var estimatedProgress: Double = 0.0
}

#Preview {
    NavigationStack {
        SimpleWebViewDemo()
    }
}
