/// @author Dambert Muñoz
/// Example browser view using iOS 26 native WebView
///
/// NOTE: This view demonstrates the API patterns for iOS 26's native WebView.
/// The actual WebView, WebViewReader, and related types are provided by
/// Apple's SwiftUI framework in iOS 26.

import SwiftUI

#if os(iOS)
/// Example browser interface demonstrating iOS 26 WebView patterns
public struct BrowserView: View {
    @State private var viewModel = BrowserViewModel()
    @State private var showBookmarks = false

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress bar
                if viewModel.state.isLoading {
                    ProgressView(value: viewModel.state.loadingProgress)
                        .tint(.blue)
                }

                // URL bar
                urlBar

                // Web content area
                webContentArea

                // Navigation toolbar
                navigationToolbar
            }
            .navigationTitle(viewModel.state.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showBookmarks = true
                    } label: {
                        Image(systemName: "book")
                    }
                }
            }
            .sheet(isPresented: $showBookmarks) {
                bookmarksList
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { viewModel.showError = false }
            } message: {
                Text(viewModel.state.error?.localizedDescription ?? "Unknown error")
            }
        }
    }

    // MARK: - URL Bar

    private var urlBar: some View {
        HStack {
            Image(systemName: viewModel.state.currentURL?.scheme == "https" ? "lock.fill" : "lock.open")
                .foregroundStyle(viewModel.state.currentURL?.scheme == "https" ? .green : .orange)
                .font(.caption)

            TextField("Enter URL", text: $viewModel.urlInput)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit {
                    viewModel.navigateTo(viewModel.urlInput)
                }

            if viewModel.state.isLoading {
                ProgressView()
                    .scaleEffect(0.7)
            } else {
                Button {
                    viewModel.navigateTo(viewModel.urlInput)
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    // MARK: - Web Content

    private var webContentArea: some View {
        // In iOS 26, this would be:
        //
        // WebViewReader { proxy in
        //     WebView(url: viewModel.state.currentURL ?? URL(string: "about:blank")!)
        //         .webViewCurrentURL($viewModel.state.currentURL)
        //         .webViewTitle($viewModel.state.title)
        //         .webViewIsLoading($viewModel.state.isLoading)
        //         .onWebViewNavigation { event in
        //             viewModel.handleNavigationEvent(event)
        //         }
        // }
        //
        // For now, showing a placeholder:

        Group {
            if let url = viewModel.state.currentURL {
                VStack {
                    Spacer()
                    Image(systemName: "globe")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    Text("WebView Placeholder")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(url.absoluteString)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
            } else {
                ContentUnavailableView(
                    "No Page Loaded",
                    systemImage: "safari",
                    description: Text("Enter a URL to browse")
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }

    // MARK: - Navigation Toolbar

    private var navigationToolbar: some View {
        HStack(spacing: 40) {
            Button {
                // proxy.goBack()
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(!viewModel.state.canGoBack)

            Button {
                // proxy.goForward()
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(!viewModel.state.canGoForward)

            Button {
                // proxy.reload()
            } label: {
                Image(systemName: "arrow.clockwise")
            }

            Button {
                viewModel.addBookmark()
            } label: {
                Image(systemName: "star")
            }

            Button {
                // Share sheet
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .font(.title3)
        .padding()
        .background(.ultraThinMaterial)
    }

    // MARK: - Bookmarks

    private var bookmarksList: some View {
        NavigationStack {
            List {
                ForEach(viewModel.bookmarks) { bookmark in
                    Button {
                        viewModel.navigateTo(bookmark.url.absoluteString)
                        showBookmarks = false
                    } label: {
                        VStack(alignment: .leading) {
                            Text(bookmark.title)
                                .font(.headline)
                            Text(bookmark.url.host ?? "")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.removeBookmark(viewModel.bookmarks[$0]) }
                }
            }
            .navigationTitle("Bookmarks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showBookmarks = false }
                }
            }
        }
    }
}

#Preview {
    BrowserView()
}
#endif
