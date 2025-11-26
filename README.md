# SwiftUI Native WebView (iOS 26)

[![Swift](https://img.shields.io/badge/Swift-6.0+-F05138.svg?style=flat&logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-26.0+-007AFF.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Author](https://img.shields.io/badge/Author-Dambert%20Muñoz-blue.svg)](https://dambertmunoz.com)

> **Dambert Muñoz** | Senior iOS Swift Developer | 12+ years experience

## Overview

iOS 26 introduces **native WebView support in SwiftUI**, eliminating the need for `UIViewRepresentable` wrappers around `WKWebView`. This is one of the most requested features since SwiftUI's introduction.

This repository demonstrates the new WebView APIs including `WebViewReader`, JavaScript bridge, navigation handling, and custom configurations.

## What's New in iOS 26

| Before (iOS 17) | After (iOS 26) |
|-----------------|----------------|
| `UIViewRepresentable` + `WKWebView` | Native `WebView` |
| Manual coordinator pattern | Built-in `WebViewReader` |
| Complex JS bridge setup | Native `@JSExport` |
| Manual navigation delegates | `.onWebViewNavigation` modifier |
| No state binding | `@Binding` for URL, title, loading |

## Core Features

### Basic WebView

```swift
import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://apple.com")!)
    }
}
```

That's it. No more `UIViewRepresentable`, no coordinators, no boilerplate.

### WebViewReader for Control

```swift
struct BrowserView: View {
    @State private var urlString = "https://apple.com"
    
    var body: some View {
        WebViewReader { proxy in
            VStack {
                HStack {
                    Button("Back") { proxy.goBack() }
                    Button("Forward") { proxy.goForward() }
                    Button("Reload") { proxy.reload() }
                }
                
                WebView(url: URL(string: urlString)!)
            }
        }
    }
}
```

### Navigation State Binding

```swift
struct StatefulWebView: View {
    @State private var currentURL: URL?
    @State private var pageTitle: String = ""
    @State private var isLoading: Bool = false
    @State private var loadingProgress: Double = 0
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView(value: loadingProgress)
            }
            
            Text(pageTitle)
                .font(.headline)
            
            WebView(url: URL(string: "https://apple.com")!)
                .webViewCurrentURL($currentURL)
                .webViewTitle($pageTitle)
                .webViewIsLoading($isLoading)
                .webViewLoadingProgress($loadingProgress)
        }
    }
}
```

### JavaScript Bridge

```swift
struct JSBridgeView: View {
    @State private var message = ""
    
    var body: some View {
        WebViewReader { proxy in
            VStack {
                Text("From JS: \(message)")
                
                Button("Call JavaScript") {
                    Task {
                        let result = try await proxy.evaluateJavaScript(
                            "document.title"
                        )
                        message = result as? String ?? ""
                    }
                }
                
                WebView(url: URL(string: "https://apple.com")!)
                    .onJavaScriptMessage("nativeCallback") { message in
                        self.message = message.body as? String ?? ""
                    }
            }
        }
    }
}
```

### Navigation Events

```swift
WebView(url: URL(string: "https://apple.com")!)
    .onWebViewNavigation { action in
        switch action {
        case .didStartNavigation(let url):
            print("Started loading: \(url)")
        case .didFinishNavigation(let url):
            print("Finished loading: \(url)")
        case .didFailNavigation(let error):
            print("Failed: \(error)")
        case .didReceiveChallenge(let challenge):
            // Handle SSL challenges
            return .performDefaultHandling
        }
    }
    .onWebViewNavigationDecision { url in
        // Return false to block navigation
        return !url.host?.contains("blocked.com") ?? true
    }
```

### Custom Configuration

```swift
WebView(url: URL(string: "https://apple.com")!)
    .webViewConfiguration { config in
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
    }
    .webViewAllowsBackForwardNavigationGestures(true)
    .webViewAllowsLinkPreview(true)
```

## Architecture

This project follows Clean Architecture:

```
Sources/NativeWebView/
├── Domain/
│   ├── Entities/
│   │   ├── WebViewState.swift
│   │   └── NavigationEvent.swift
│   └── UseCases/
│       └── WebContentUseCase.swift
├── Presentation/
│   ├── Views/
│   │   ├── BrowserView.swift
│   │   └── WebContentView.swift
│   └── ViewModels/
│       └── BrowserViewModel.swift
└── Core/
    └── Extensions/
        └── URL+Validation.swift
```

## Requirements

| Requirement | Version |
|-------------|---------|
| iOS | 26.0+ |
| macOS | 16.0+ |
| Swift | 6.0+ |
| Xcode | 17.0+ |

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/dambertmunoz/dm-swift-swiftui-native-webview", from: "1.0.0")
]
```

## Migration from WKWebView

### Before (iOS 17)

```swift
import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Handle finish
        }
    }
}
```

### After (iOS 26)

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://apple.com")!)
            .onWebViewNavigation { action in
                if case .didFinishNavigation = action {
                    // Handle finish
                }
            }
    }
}
```

From ~40 lines to ~10 lines. Pure SwiftUI.

## Author

**Dambert Muñoz**

Senior iOS Swift Developer | 12+ years experience

- 🌐 [dambertmunoz.com](https://dambertmunoz.com)
- 💼 [LinkedIn](https://linkedin.com/in/dambert-m-4b772397)
- 🐙 [GitHub](https://github.com/dambertmunoz)
- 📧 dmsantillana2705@gmail.com

## License

MIT License © 2025 Dambert Muñoz

---

Happy coding!
