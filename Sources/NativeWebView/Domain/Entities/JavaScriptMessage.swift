/// @author Dambert Muñoz
/// JavaScript message entities for WebView communication

import Foundation

/// Message received from JavaScript via the message handler bridge
public struct JavaScriptMessage {
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
    
    /// Extract body as specific type
    public func body<T>(as type: T.Type) -> T? {
        body as? T
    }
    
    /// Extract body as dictionary
    public var bodyAsDictionary: [String: Any]? {
        body as? [String: Any]
    }
    
    /// Extract body as string
    public var bodyAsString: String? {
        body as? String
    }
}

/// Information about the frame that sent the message
public struct FrameInfo: Sendable {
    public let isMainFrame: Bool
    public let url: URL?
    public let securityOrigin: SecurityOrigin?
    
    public init(
        isMainFrame: Bool = true,
        url: URL? = nil,
        securityOrigin: SecurityOrigin? = nil
    ) {
        self.isMainFrame = isMainFrame
        self.url = url
        self.securityOrigin = securityOrigin
    }
    
    public static let main = FrameInfo(isMainFrame: true)
}

/// Security origin information
public struct SecurityOrigin: Sendable, Equatable {
    public let host: String
    public let port: Int
    public let `protocol`: String
    
    public init(host: String, port: Int, protocol: String) {
        self.host = host
        self.port = port
        self.protocol = `protocol`
    }
    
    public var origin: String {
        "\(`protocol`)://\(host)\(port != 0 ? ":\(port)" : "")"
    }
}
