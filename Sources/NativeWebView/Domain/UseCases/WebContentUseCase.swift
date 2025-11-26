/// @author Dambert Muñoz
/// Use case for web content operations

import Foundation

/// Protocol for web content operations
public protocol WebContentUseCaseProtocol: Sendable {
    func validateURL(_ urlString: String) -> Result<URL, WebViewError>
    func shouldAllowNavigation(to url: URL, blockedDomains: [String]) -> Bool
    func extractDomain(from url: URL) -> String?
}

/// Implementation of web content use case
public final class WebContentUseCase: WebContentUseCaseProtocol, @unchecked Sendable {

    public init() {}

    public func validateURL(_ urlString: String) -> Result<URL, WebViewError> {
        // Try as-is first
        if let url = URL(string: urlString), url.scheme != nil {
            return .success(url)
        }

        // Try adding https://
        let httpsString = "https://\(urlString)"
        if let url = URL(string: httpsString) {
            return .success(url)
        }

        return .failure(.invalidURL)
    }

    public func shouldAllowNavigation(to url: URL, blockedDomains: [String]) -> Bool {
        guard let host = url.host?.lowercased() else {
            return true
        }

        for domain in blockedDomains {
            if host.contains(domain.lowercased()) {
                return false
            }
        }

        return true
    }

    public func extractDomain(from url: URL) -> String? {
        url.host
    }
}
