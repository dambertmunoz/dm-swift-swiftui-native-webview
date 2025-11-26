/// @author Dambert Muñoz
/// Tests for WebViewState

import Testing
@testable import NativeWebView

@Suite("WebViewState Tests")
struct WebViewStateTests {

    @Test("Initial state has default values")
    func testInitialState() {
        let state = WebViewState.initial

        #expect(state.currentURL == nil)
        #expect(state.title == "")
        #expect(!state.isLoading)
        #expect(state.loadingProgress == 0)
        #expect(!state.canGoBack)
        #expect(!state.canGoForward)
        #expect(state.error == nil)
    }

    @Test("State with custom values")
    func testCustomState() {
        let url = URL(string: "https://apple.com")!
        let state = WebViewState(
            currentURL: url,
            title: "Apple",
            isLoading: true,
            loadingProgress: 0.5,
            canGoBack: true,
            canGoForward: false
        )

        #expect(state.currentURL == url)
        #expect(state.title == "Apple")
        #expect(state.isLoading)
        #expect(state.loadingProgress == 0.5)
        #expect(state.canGoBack)
        #expect(!state.canGoForward)
    }
}

@Suite("WebViewError Tests")
struct WebViewErrorTests {

    @Test("Error descriptions are correct", arguments: [
        (WebViewError.invalidURL, "The URL is invalid"),
        (WebViewError.timeout, "Request timed out"),
        (WebViewError.contentBlocked, "Content was blocked")
    ])
    func testErrorDescriptions(error: WebViewError, expected: String) {
        #expect(error.localizedDescription == expected)
    }

    @Test("Network error includes message")
    func testNetworkError() {
        let error = WebViewError.networkError("No connection")
        #expect(error.localizedDescription.contains("No connection"))
    }
}

@Suite("WebViewConfiguration Tests")
struct WebViewConfigurationTests {

    @Test("Default configuration has expected values")
    func testDefaultConfig() {
        let config = WebViewConfiguration.default

        #expect(config.allowsInlineMediaPlayback)
        #expect(config.allowsBackForwardGestures)
        #expect(config.allowsLinkPreview)
        #expect(config.javaScriptEnabled)
        #expect(config.customUserAgent == nil)
    }

    @Test("Custom configuration")
    func testCustomConfig() {
        let config = WebViewConfiguration(
            allowsInlineMediaPlayback: false,
            javaScriptEnabled: false,
            customUserAgent: "MyApp/1.0"
        )

        #expect(!config.allowsInlineMediaPlayback)
        #expect(!config.javaScriptEnabled)
        #expect(config.customUserAgent == "MyApp/1.0")
    }
}
