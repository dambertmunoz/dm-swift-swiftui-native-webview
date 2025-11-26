# NativeWebViewDemo

Example app demonstrating iOS 26 SwiftUI Native WebView capabilities.

## Running the Demo

### Option 1: Swift Package Manager (Recommended)

```bash
cd dm-swift-swiftui-native-webview
swift build
swift run NativeWebViewDemo
```

### Option 2: Xcode

1. Open `Package.swift` in Xcode
2. Select `NativeWebViewDemo` scheme
3. Select iOS 18+ simulator
4. Build and run (Cmd+R)

## Demo Screens

### Basic Examples

| Demo | Description |
|------|-------------|
| **Simple WebView** | Minimal WebView with just a URL |
| **Stateful WebView** | Track loading state, progress, title |

### Advanced Examples

| Demo | Description |
|------|-------------|
| **Full Browser** | Complete browser with navigation controls |
| **JavaScript Bridge** | Swift <-> JavaScript communication |
| **Custom HTML** | Load and render custom HTML content |

## Key APIs Demonstrated

```swift
// Basic
WebView(url: URL)

// With state binding
WebView(url: URL, state: $webState)

// With navigation controls
WebViewReader { proxy in
    WebView(url: url)
    Button("Back") { proxy.goBack() }
    Button("JS") {
        Task {
            let title = try await proxy.evaluateJavaScript("document.title")
        }
    }
}
```

## Architecture

The demo uses:
- **NativeWebView library**: Core WebView components and state management
- **Clean Architecture**: Domain entities, Use Cases, Presentation layer
- **MVVM pattern**: ViewModels with @Observable

## Author

Dambert Muñoz - Senior iOS Developer
