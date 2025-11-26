/// @author Dambert Muñoz
/// WebView state entities for tracking navigation and loading

import Foundation

/// Represents the current state of a WebView
public struct WebViewState: Sendable, Equatable {
    public var currentURL: URL?
    public var title: String
    public var isLoading: Bool
    public var loadingProgress: Double
    public var canGoBack: Bool
    public var canGoForward: Bool
    public var error: WebViewError?

    public init(
        currentURL: URL? = nil,
        title: String = "",
        isLoading: Bool = false,
        loadingProgress: Double = 0,
        canGoBack: Bool = false,
        canGoForward: Bool = false,
        error: WebViewError? = nil
    ) {
        self.currentURL = currentURL
        self.title = title
        self.isLoading = isLoading
        self.loadingProgress = loadingProgress
        self.canGoBack = canGoBack
        self.canGoForward = canGoForward
        self.error = error
    }

    public static let initial = WebViewState()
}

/// WebView-specific errors
public enum WebViewError: Error, Sendable, Equatable {
    case invalidURL
    case networkError(String)
    case sslError(String)
    case contentBlocked
    case timeout
    case unknown(String)

    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .networkError(let message):
            return "Network error: \(message)"
        case .sslError(let message):
            return "SSL error: \(message)"
        case .contentBlocked:
            return "Content was blocked"
        case .timeout:
            return "Request timed out"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}

/// Configuration for WebView behavior
public struct WebViewConfiguration: Sendable {
    public var allowsInlineMediaPlayback: Bool
    public var mediaTypesRequiringUserAction: MediaTypes
    public var allowsBackForwardGestures: Bool
    public var allowsLinkPreview: Bool
    public var javaScriptEnabled: Bool
    public var customUserAgent: String?

    public init(
        allowsInlineMediaPlayback: Bool = true,
        mediaTypesRequiringUserAction: MediaTypes = [],
        allowsBackForwardGestures: Bool = true,
        allowsLinkPreview: Bool = true,
        javaScriptEnabled: Bool = true,
        customUserAgent: String? = nil
    ) {
        self.allowsInlineMediaPlayback = allowsInlineMediaPlayback
        self.mediaTypesRequiringUserAction = mediaTypesRequiringUserAction
        self.allowsBackForwardGestures = allowsBackForwardGestures
        self.allowsLinkPreview = allowsLinkPreview
        self.javaScriptEnabled = javaScriptEnabled
        self.customUserAgent = customUserAgent
    }

    public static let `default` = WebViewConfiguration()

    public struct MediaTypes: OptionSet, Sendable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        public static let audio = MediaTypes(rawValue: 1 << 0)
        public static let video = MediaTypes(rawValue: 1 << 1)
        public static let all: MediaTypes = [.audio, .video]
    }
}
