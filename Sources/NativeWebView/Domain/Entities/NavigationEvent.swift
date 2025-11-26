/// @author Dambert Muñoz
/// Navigation events for WebView

import Foundation

/// Events emitted during WebView navigation
public enum NavigationEvent: Sendable {
    case didStartNavigation(URL)
    case didCommitNavigation(URL)
    case didFinishNavigation(URL)
    case didFailNavigation(WebViewError)
    case didReceiveChallenge(URLAuthenticationChallenge)
    case didReceiveServerRedirect(from: URL, to: URL)

    public var url: URL? {
        switch self {
        case .didStartNavigation(let url),
             .didCommitNavigation(let url),
             .didFinishNavigation(let url):
            return url
        case .didReceiveServerRedirect(_, let to):
            return to
        default:
            return nil
        }
    }
}

/// Decision for navigation requests
public enum NavigationDecision: Sendable {
    case allow
    case cancel
    case download
}

/// Authentication challenge response
public enum ChallengeResponse: Sendable {
    case performDefaultHandling
    case useCredential(URLCredential)
    case cancelChallenge
    case rejectProtectionSpace
}

/// URL authentication challenge placeholder
public struct URLAuthenticationChallenge: Sendable {
    public let host: String
    public let port: Int
    public let protectionSpace: String
    public let proposedCredential: URLCredential?

    public init(
        host: String,
        port: Int = 443,
        protectionSpace: String = "https",
        proposedCredential: URLCredential? = nil
    ) {
        self.host = host
        self.port = port
        self.protectionSpace = protectionSpace
        self.proposedCredential = proposedCredential
    }
}

/// URL credential for authentication
public struct URLCredential: Sendable {
    public let user: String
    public let password: String
    public let persistence: Persistence

    public enum Persistence: Sendable {
        case none
        case forSession
        case permanent
        case synchronizable
    }

    public init(user: String, password: String, persistence: Persistence = .forSession) {
        self.user = user
        self.password = password
        self.persistence = persistence
    }
}
