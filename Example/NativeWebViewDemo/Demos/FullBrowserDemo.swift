//
//  FullBrowserDemo.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI

/// Complete browser with navigation controls using WebViewReader
struct FullBrowserDemo: View {
    @State private var urlString = "https://www.apple.com"
    @State private var webState = WebViewState()
    @State private var showShareSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // URL Bar
            urlBar
            
            // Progress
            if webState.isLoading {
                ProgressView(value: webState.estimatedProgress)
                    .progressViewStyle(.linear)
                    .tint(.blue)
            }
            
            // WebView with Reader for controls
            WebViewReader { proxy in
                WebView(
                    url: URL(string: urlString) ?? URL(string: "https://apple.com")!,
                    state: $webState
                )
                
                // Navigation toolbar
                navigationToolbar(proxy: proxy)
            }
        }
        .navigationTitle(webState.title ?? "Browser")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    private var urlBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .submitLabel(.go)
                .onSubmit {
                    // URL will update WebView
                }
            
            if !urlString.isEmpty {
                Button {
                    urlString = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private func navigationToolbar(proxy: WebViewProxy) -> some View {
        HStack(spacing: 0) {
            // Back
            Button {
                proxy.goBack()
            } label: {
                Image(systemName: "chevron.left")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!webState.canGoBack)
            
            // Forward
            Button {
                proxy.goForward()
            } label: {
                Image(systemName: "chevron.right")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!webState.canGoForward)
            
            // Reload / Stop
            Button {
                if webState.isLoading {
                    proxy.stopLoading()
                } else {
                    proxy.reload()
                }
            } label: {
                Image(systemName: webState.isLoading ? "xmark" : "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            
            // Home
            Button {
                urlString = "https://www.apple.com"
            } label: {
                Image(systemName: "house")
                    .frame(maxWidth: .infinity)
            }
        }
        .font(.system(size: 18))
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
    }
}

// MARK: - WebViewReader & Proxy Placeholder
// Remove when compiling for iOS 26+

struct WebViewReader<Content: View>: View {
    let content: (WebViewProxy) -> Content
    
    init(@ViewBuilder content: @escaping (WebViewProxy) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(WebViewProxy())
    }
}

struct WebViewProxy {
    func goBack() { print("goBack()") }
    func goForward() { print("goForward()") }
    func reload() { print("reload()") }
    func stopLoading() { print("stopLoading()") }
    func evaluateJavaScript(_ script: String) async throws -> Any? { nil }
    func loadHTMLString(_ html: String, baseURL: URL?) { print("loadHTML") }
}

#Preview {
    NavigationStack {
        FullBrowserDemo()
    }
}
