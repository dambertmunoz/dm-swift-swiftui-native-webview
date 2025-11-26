//
//  CustomHTMLDemo.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI

/// Load custom HTML content directly
struct CustomHTMLDemo: View {
    @State private var selectedTemplate = 0
    @State private var webState = WebViewState()
    
    private let templates = [
        HTMLTemplate(
            name: "Welcome Card",
            html: """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    * { margin: 0; padding: 0; box-sizing: border-box; }
                    body {
                        font-family: -apple-system;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        min-height: 100vh;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 20px;
                    }
                    .card {
                        background: white;
                        border-radius: 20px;
                        padding: 40px;
                        text-align: center;
                        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                        max-width: 320px;
                    }
                    h1 { color: #1d1d1f; margin-bottom: 12px; }
                    p { color: #86868b; line-height: 1.5; }
                    .emoji { font-size: 48px; margin-bottom: 16px; }
                </style>
            </head>
            <body>
                <div class="card">
                    <div class="emoji">👋</div>
                    <h1>Welcome!</h1>
                    <p>This content is rendered using iOS 26 native WebView with custom HTML.</p>
                </div>
            </body>
            </html>
            """
        ),
        HTMLTemplate(
            name: "Data Dashboard",
            html: """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body {
                        font-family: -apple-system;
                        background: #000;
                        color: white;
                        padding: 20px;
                    }
                    .grid {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 16px;
                    }
                    .stat {
                        background: #1c1c1e;
                        border-radius: 16px;
                        padding: 20px;
                    }
                    .value {
                        font-size: 32px;
                        font-weight: bold;
                        color: #30d158;
                    }
                    .label {
                        color: #86868b;
                        font-size: 14px;
                        margin-top: 4px;
                    }
                    h2 { margin-bottom: 20px; }
                </style>
            </head>
            <body>
                <h2>Dashboard</h2>
                <div class="grid">
                    <div class="stat">
                        <div class="value">2.4K</div>
                        <div class="label">Users</div>
                    </div>
                    <div class="stat">
                        <div class="value">98%</div>
                        <div class="label">Uptime</div>
                    </div>
                    <div class="stat">
                        <div class="value">1.2s</div>
                        <div class="label">Response</div>
                    </div>
                    <div class="stat">
                        <div class="value">99.9</div>
                        <div class="label">Score</div>
                    </div>
                </div>
            </body>
            </html>
            """
        ),
        HTMLTemplate(
            name: "Interactive Form",
            html: """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body {
                        font-family: -apple-system;
                        background: #f5f5f7;
                        padding: 20px;
                    }
                    .form-group {
                        background: white;
                        border-radius: 12px;
                        padding: 16px;
                        margin-bottom: 12px;
                    }
                    label {
                        display: block;
                        color: #86868b;
                        font-size: 13px;
                        margin-bottom: 8px;
                    }
                    input, textarea {
                        width: 100%;
                        border: none;
                        font-size: 17px;
                        outline: none;
                    }
                    textarea { resize: none; height: 80px; }
                    button {
                        width: 100%;
                        background: #007AFF;
                        color: white;
                        border: none;
                        padding: 16px;
                        border-radius: 12px;
                        font-size: 17px;
                        font-weight: 600;
                    }
                    h2 { margin-bottom: 20px; color: #1d1d1f; }
                </style>
            </head>
            <body>
                <h2>Contact Form</h2>
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" placeholder="Your name">
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" placeholder="email@example.com">
                </div>
                <div class="form-group">
                    <label>Message</label>
                    <textarea placeholder="Your message..."></textarea>
                </div>
                <button onclick="alert('Form submitted!')">Submit</button>
            </body>
            </html>
            """
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Template picker
            Picker("Template", selection: $selectedTemplate) {
                ForEach(0..<templates.count, id: \.self) { index in
                    Text(templates[index].name).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // WebView with custom HTML
            WebViewReader { proxy in
                WebView(
                    url: URL(string: "about:blank")!,
                    state: $webState
                )
                .onChange(of: selectedTemplate) { _, newValue in
                    proxy.loadHTMLString(templates[newValue].html, baseURL: nil)
                }
                .onAppear {
                    proxy.loadHTMLString(templates[selectedTemplate].html, baseURL: nil)
                }
            }
        }
        .navigationTitle("Custom HTML")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HTMLTemplate {
    let name: String
    let html: String
}

#Preview {
    NavigationStack {
        CustomHTMLDemo()
    }
}
