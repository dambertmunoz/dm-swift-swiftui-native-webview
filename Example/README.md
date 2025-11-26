# NativeWebViewDemo

Example app demonstrating iOS 26 SwiftUI Native WebView capabilities.

## Requirements

- Xcode 26+
- iOS 26+ Simulator or Device
- macOS 15+

## Running the Demo

1. Open `NativeWebViewDemo` folder in Xcode
2. Select iOS 26+ simulator
3. Build and run

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
| **JavaScript Bridge** | Swift ↔ JavaScript communication |
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
}

// JavaScript bridge
.onJavaScriptMessage("handler") { message in
    print(message.body)
}
```

## Note

This demo includes placeholder implementations for iOS < 26.
The actual `WebView`, `WebViewReader`, and `WebViewProxy` types
are provided by SwiftUI in iOS 26+.

Remove the placeholder code when compiling for iOS 26.

## Author

Dambert Muñoz - Senior iOS Developer
