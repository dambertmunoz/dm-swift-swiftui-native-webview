//
//  SimpleWebViewDemo.swift
//  NativeWebViewDemo
//
//  Created by Dambert Muñoz
//

import SwiftUI
import NativeWebView

/// Most basic WebView usage - just a URL
struct SimpleWebViewDemo: View {
    var body: some View {
        WebView(url: URL(string: "https://developer.apple.com/swift/")!)
            .navigationTitle("Simple WebView")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SimpleWebViewDemo()
    }
}
