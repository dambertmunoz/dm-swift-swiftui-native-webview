/// @author Dambert Muñoz
/// URL extensions for validation and manipulation

import Foundation

extension URL {

    /// Returns true if the URL uses a secure scheme (https)
    public var isSecure: Bool {
        scheme?.lowercased() == "https"
    }

    /// Returns true if this is a valid web URL
    public var isWebURL: Bool {
        guard let scheme = scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }

    /// Returns the display host (without www prefix)
    public var displayHost: String? {
        guard var host = host?.lowercased() else { return nil }
        if host.hasPrefix("www.") {
            host = String(host.dropFirst(4))
        }
        return host
    }

    /// Creates a URL from a search query or URL string
    public static func fromSearchOrURL(_ input: String, searchEngine: SearchEngine = .google) -> URL? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if it's already a valid URL
        if let url = URL(string: trimmed), url.scheme != nil {
            return url
        }

        // Check if it looks like a domain
        if trimmed.contains(".") && !trimmed.contains(" ") {
            return URL(string: "https://\(trimmed)")
        }

        // Treat as search query
        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trimmed
        return URL(string: searchEngine.searchURL(for: encoded))
    }
}

/// Supported search engines
public enum SearchEngine: String, CaseIterable, Sendable {
    case google
    case duckDuckGo
    case bing
    case ecosia

    public var displayName: String {
        switch self {
        case .google: return "Google"
        case .duckDuckGo: return "DuckDuckGo"
        case .bing: return "Bing"
        case .ecosia: return "Ecosia"
        }
    }

    public func searchURL(for query: String) -> String {
        switch self {
        case .google:
            return "https://www.google.com/search?q=\(query)"
        case .duckDuckGo:
            return "https://duckduckgo.com/?q=\(query)"
        case .bing:
            return "https://www.bing.com/search?q=\(query)"
        case .ecosia:
            return "https://www.ecosia.org/search?q=\(query)"
        }
    }
}
