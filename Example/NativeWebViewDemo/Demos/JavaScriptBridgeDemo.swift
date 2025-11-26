//
//  JavaScriptBridgeDemo.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI
import NativeWebView

/// Demonstrates JavaScript <-> Swift communication
struct JavaScriptBridgeDemo: View {
    @State private var messages: [JSMessage] = []
    @State private var documentTitle = "Unknown"
    @State private var webState = WebViewState.initial
    
    var body: some View {
        VStack(spacing: 0) {
            // WebView with JS message handler
            WebViewReader { proxy in
                VStack(spacing: 0) {
                    WebView(
                        url: URL(string: "https://www.apple.com")!,
                        state: $webState
                    )
                    
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
                        
                        Button("Execute Custom JS") {
                            Task {
                                _ = try? await proxy.evaluateJavaScript(
                                    "console.log('Hello from Swift!')"
                                )
                                messages.append(JSMessage(body: "Executed console.log"))
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
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
            
            Text("JavaScript Messages:")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if messages.isEmpty {
                Text("No messages yet")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(messages.suffix(5)) { msg in
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
