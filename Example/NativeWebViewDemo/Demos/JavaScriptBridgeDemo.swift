//
//  JavaScriptBridgeDemo.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI

/// Demonstrates JavaScript ↔ Swift communication
struct JavaScriptBridgeDemo: View {
    @State private var messages: [JSMessage] = []
    @State private var documentTitle = "Unknown"
    @State private var webState = WebViewState()
    
    private let demoHTML = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>JS Bridge Demo</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body { 
                font-family: -apple-system; 
                padding: 20px;
                background: #f5f5f7;
            }
            button {
                background: #007AFF;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-size: 16px;
                margin: 8px 4px;
                cursor: pointer;
            }
            button:active { opacity: 0.8; }
            .message-box {
                background: white;
                padding: 16px;
                border-radius: 12px;
                margin: 16px 0;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            h1 { color: #1d1d1f; }
            code { 
                background: #e5e5e7; 
                padding: 2px 6px; 
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <h1>JavaScript Bridge</h1>
        
        <div class="message-box">
            <p>Tap buttons to send messages to Swift:</p>
            <button onclick="sendToSwift('greeting', 'Hello from JavaScript!')">Send Greeting</button>
            <button onclick="sendToSwift('counter', Date.now())">Send Timestamp</button>
            <button onclick="sendToSwift('data', {name: 'Test', value: 42})">Send Object</button>
        </div>
        
        <div class="message-box">
            <p>Swift can call JavaScript:</p>
            <p>Document title: <code id="title-display">JS Bridge Demo</code></p>
            <p>Last Swift message: <code id="swift-message">None</code></p>
        </div>
        
        <script>
            function sendToSwift(type, payload) {
                // iOS 26+ native handler
                if (window.webkit?.messageHandlers?.nativeHandler) {
                    window.webkit.messageHandlers.nativeHandler.postMessage({
                        type: type,
                        payload: payload,
                        timestamp: new Date().toISOString()
                    });
                } else {
                    console.log('Native handler not available:', type, payload);
                }
            }
            
            // Function Swift can call
            function receiveFromSwift(message) {
                document.getElementById('swift-message').textContent = message;
                return 'Received: ' + message;
            }
        </script>
    </body>
    </html>
    """
    
    var body: some View {
        VStack(spacing: 0) {
            // WebView with JS message handler
            WebViewReader { proxy in
                WebView(
                    url: URL(string: "about:blank")!,
                    state: $webState
                )
                .onAppear {
                    proxy.loadHTMLString(demoHTML, baseURL: nil)
                }
                // Handle messages from JavaScript
                // .onJavaScriptMessage("nativeHandler") { message in
                //     messages.append(JSMessage(body: message.body))
                // }
                
                // Controls
                VStack(spacing: 12) {
                    Button("Get Document Title") {
                        Task {
                            if let title = try? await proxy.evaluateJavaScript("document.title") as? String {
                                documentTitle = title
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Call JS Function") {
                        Task {
                            _ = try? await proxy.evaluateJavaScript(
                                "receiveFromSwift('Hello from Swift!')"
                            )
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            
            // Messages received
            messagesPanel
        }
        .navigationTitle("JS Bridge")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Document Title: \(documentTitle)")
                .font(.caption)
            
            Divider()
            
            Text("Messages from JS:")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if messages.isEmpty {
                Text("No messages yet")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(messages.suffix(3)) { msg in
                    Text(msg.description)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
    }
}

struct JSMessage: Identifiable {
    let id = UUID()
    let body: Any
    let timestamp = Date()
    
    var description: String {
        "[\(timestamp.formatted(date: .omitted, time: .standard))] \(body)"
    }
}

#Preview {
    NavigationStack {
        JavaScriptBridgeDemo()
    }
}
