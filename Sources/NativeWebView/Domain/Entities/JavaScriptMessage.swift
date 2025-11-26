/// @author Dambert Muñoz
/// JavaScript message handling for WebView

import Foundation

/// Message received from JavaScript
public struct JavaScriptMessage: Sendable {
    public let name: String
    public let body: Any
    public let frameInfo: FrameInfo
    public let timestamp: Date

    public init(
        name: String,
        body: Any,
        frameInfo: FrameInfo = .main,
        timestamp: Date = Date()
    ) {
        self.name = name
        self.body = body
        self.frameInfo = frameInfo
        self.timestamp = timestamp
    }

    /// Attempts to decode the body as a specific type
    public func bodyAs<T>(_ type: T.Type) -> T? {
        body as? T
    }

    /// Attempts to decode the body as a dictionary
    public var bodyAsDictionary: [String: Any]? {
        body as? [String: Any]
    }

    /// Attempts to decode the body as a string
    public var bodyAsString: String? {
        body as? String
    }
}

/// Information about the frame that sent the message
public struct FrameInfo: Sendable {
    public let isMainFrame: Bool
    public let request: URLRequest?
    public let securityOrigin: SecurityOrigin

    public static let main = FrameInfo(
        isMainFrame: true,
        request: nil,
        securityOrigin: .empty
    )

    public init(
        isMainFrame: Bool,
        request: URLRequest?,
        securityOrigin: SecurityOrigin
    ) {
        self.isMainFrame = isMainFrame
        self.request = request
        self.securityOrigin = securityOrigin
    }
}

/// Security origin of a frame
public struct SecurityOrigin: Sendable {
    public let host: String
    public let port: Int
    public let `protocol`: String

    public static let empty = SecurityOrigin(host: "", port: 0, protocol: "")

    public init(host: String, port: Int, protocol: String) {
        self.host = host
        self.port = port
        self.protocol = `protocol`
    }
}

/// Handler registration for JavaScript messages
public struct JavaScriptMessageHandler: Sendable {
    public let name: String
    public let handler: @Sendable (JavaScriptMessage) -> Void

    public init(name: String, handler: @escaping @Sendable (JavaScriptMessage) -> Void) {
        self.name = name
        self.handler = handler
    }
}
