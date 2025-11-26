/// @author Dambert Muñoz
/// WebView wrapper components for iOS 26 compatibility
///
/// These components provide the API surface for iOS 26's native WebView.
/// In iOS 26+, these would be provided by SwiftUI directly.
/// This implementation allows the code to compile on iOS 18+ while
/// demonstrating the expected API patterns.

import SwiftUI
import WebKit

// MARK: - WebView

/// A view that displays web content.
///
/// In iOS 26, this is a native SwiftUI component. This implementation
/// provides a compatible API surface for demonstration purposes.
///
/// Usage:
/// ```swift
/// WebView(url: URL(string: "https://apple.com")!)
/// ```
public struct WebView: View {
    private let url: URL
    @Binding private var state: WebViewState
    
    /// Creates a WebView with the specified URL.
    /// - Parameters:
    ///   - url: The URL to load
    ///   - state: Optional binding to track WebView state
    public init(url: URL, state: Binding<WebViewState> = .constant(.initial)) {
        self.url = url
        self._state = state
    }
    
    public var body: some View {
        WebViewRepresentable(url: url, state: $state)
    }
}

// MARK: - WebViewReader

/// A container that provides programmatic control over a WebView.
///
/// Use `WebViewReader` to access navigation methods like `goBack()`,
/// `goForward()`, `reload()`, and `evaluateJavaScript(_:)`.
///
/// Usage:
/// ```swift
/// WebViewReader { proxy in
///     WebView(url: currentURL)
///     Button("Back") { proxy.goBack() }
/// }
/// ```
public struct WebViewReader<Content: View>: View {
    private let content: (WebViewProxy) -> Content
    @State private var proxy = WebViewProxy()
    
    public init(@ViewBuilder content: @escaping (WebViewProxy) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(proxy)
    }
}

// MARK: - WebViewProxy

/// A proxy that provides methods to control a WebView programmatically.
@MainActor
public final class WebViewProxy: ObservableObject {
    @Published public var canGoBack: Bool = false
    @Published public var canGoForward: Bool = false
    
    public init() {}
    
    /// Navigates back in the WebView's history.
    public func goBack() {
        print("[WebViewProxy] goBack() called")
    }
    
    /// Navigates forward in the WebView's history.
    public func goForward() {
        print("[WebViewProxy] goForward() called")
    }
    
    /// Reloads the current page.
    public func reload() {
        print("[WebViewProxy] reload() called")
    }
    
    /// Stops loading the current page.
    public func stopLoading() {
        print("[WebViewProxy] stopLoading() called")
    }
    
    /// Evaluates JavaScript in the WebView context.
    /// - Parameter script: The JavaScript code to execute
    /// - Returns: The result of the JavaScript execution
    public func evaluateJavaScript(_ script: String) async throws -> Any? {
        print("[WebViewProxy] evaluateJavaScript: \(script)")
        // Simulated response for demo
        if script == "document.title" {
            return "Demo Page Title"
        }
        return nil
    }
    
    /// Loads custom HTML content into the WebView.
    /// - Parameters:
    ///   - html: The HTML string to load
    ///   - baseURL: Optional base URL for resolving relative links
    public func loadHTMLString(_ html: String, baseURL: URL?) {
        print("[WebViewProxy] loadHTMLString called with \(html.count) characters")
    }
}

// MARK: - WebViewRepresentable

#if os(iOS)
struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    @Binding var state: WebViewState
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(state: $state)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var state: WebViewState
        
        init(state: Binding<WebViewState>) {
            self._state = state
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            state.isLoading = true
            state.loadingProgress = 0.1
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            state.isLoading = false
            state.loadingProgress = 1.0
            state.currentURL = webView.url
            state.title = webView.title ?? ""
            state.canGoBack = webView.canGoBack
            state.canGoForward = webView.canGoForward
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            state.isLoading = false
            state.error = .networkError(error.localizedDescription)
        }
    }
}
#else
struct WebViewRepresentable: NSViewRepresentable {
    let url: URL
    @Binding var state: WebViewState
    
    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(state: $state)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var state: WebViewState
        
        init(state: Binding<WebViewState>) {
            self._state = state
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            state.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            state.isLoading = false
            state.currentURL = webView.url
            state.title = webView.title ?? ""
            state.canGoBack = webView.canGoBack
            state.canGoForward = webView.canGoForward
        }
    }
}
#endif
