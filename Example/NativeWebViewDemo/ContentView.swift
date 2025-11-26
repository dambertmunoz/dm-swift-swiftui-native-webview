//
//  ContentView.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI
import NativeWebView

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Basic Examples") {
                    NavigationLink("Simple WebView") {
                        SimpleWebViewDemo()
                    }
                    
                    NavigationLink("WebView with State") {
                        StatefulWebViewDemo()
                    }
                }
                
                Section("Advanced Examples") {
                    NavigationLink("Full Browser") {
                        FullBrowserDemo()
                    }
                    
                    NavigationLink("JavaScript Bridge") {
                        JavaScriptBridgeDemo()
                    }
                    
                    NavigationLink("Custom HTML") {
                        CustomHTMLDemo()
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("iOS 26+ Native WebView Demo")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("NativeWebView v\(NativeWebView.version)")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .navigationTitle("WebView Demos")
        }
    }
}

#Preview {
    ContentView()
}
