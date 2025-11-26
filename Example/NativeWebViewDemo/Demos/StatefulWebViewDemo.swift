//
//  StatefulWebViewDemo.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI
import NativeWebView

/// WebView with state binding to track loading, progress, title
struct StatefulWebViewDemo: View {
    @State private var webState = WebViewState.initial
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            if webState.isLoading {
                ProgressView(value: webState.loadingProgress)
                    .progressViewStyle(.linear)
                    .tint(.blue)
            }
            
            // WebView
            WebView(
                url: URL(string: "https://www.apple.com")!,
                state: $webState
            )
            
            // State info panel
            stateInfoPanel
        }
        .navigationTitle(webState.title.isEmpty ? "Loading..." : webState.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var stateInfoPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Loading", systemImage: webState.isLoading ? "circle.fill" : "circle")
                    .foregroundStyle(webState.isLoading ? .blue : .secondary)
                
                Spacer()
                
                Text("\(Int(webState.loadingProgress * 100))%")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            
            if let currentURL = webState.currentURL {
                Text(currentURL.absoluteString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            HStack {
                Label("Back", systemImage: "chevron.left")
                    .foregroundStyle(webState.canGoBack ? .primary : .tertiary)
                
                Label("Forward", systemImage: "chevron.right")
                    .foregroundStyle(webState.canGoForward ? .primary : .tertiary)
            }
            .font(.caption)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        StatefulWebViewDemo()
    }
}
