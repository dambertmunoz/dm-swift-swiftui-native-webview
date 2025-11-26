/// @author Dambert Muñoz
/// ViewModel for browser functionality

import SwiftUI

/// Observable ViewModel for browser state management
@Observable
@MainActor
public final class BrowserViewModel {

    // MARK: - State

    public private(set) var state: WebViewState = .initial
    public private(set) var history: [URL] = []
    public private(set) var bookmarks: [Bookmark] = []

    public var urlInput: String = ""
    public var showError: Bool = false

    // MARK: - Dependencies

    private let webContentUseCase: WebContentUseCaseProtocol
    private let blockedDomains: [String]

    // MARK: - Init

    public init(
        webContentUseCase: WebContentUseCaseProtocol = WebContentUseCase(),
        blockedDomains: [String] = []
    ) {
        self.webContentUseCase = webContentUseCase
        self.blockedDomains = blockedDomains
    }

    // MARK: - Actions

    public func navigateTo(_ urlString: String) {
        let result = webContentUseCase.validateURL(urlString)

        switch result {
        case .success(let url):
            state.currentURL = url
            state.error = nil
            addToHistory(url)
        case .failure(let error):
            state.error = error
            showError = true
        }
    }

    public func updateState(
        url: URL? = nil,
        title: String? = nil,
        isLoading: Bool? = nil,
        progress: Double? = nil,
        canGoBack: Bool? = nil,
        canGoForward: Bool? = nil
    ) {
        if let url { state.currentURL = url }
        if let title { state.title = title }
        if let isLoading { state.isLoading = isLoading }
        if let progress { state.loadingProgress = progress }
        if let canGoBack { state.canGoBack = canGoBack }
        if let canGoForward { state.canGoForward = canGoForward }
    }

    public func handleNavigationEvent(_ event: NavigationEvent) {
        switch event {
        case .didStartNavigation:
            state.isLoading = true
        case .didFinishNavigation(let url):
            state.isLoading = false
            state.currentURL = url
        case .didFailNavigation(let error):
            state.isLoading = false
            state.error = error
            showError = true
        default:
            break
        }
    }

    public func shouldAllowNavigation(to url: URL) -> Bool {
        webContentUseCase.shouldAllowNavigation(to: url, blockedDomains: blockedDomains)
    }

    public func addBookmark() {
        guard let url = state.currentURL else { return }
        let bookmark = Bookmark(
            url: url,
            title: state.title.isEmpty ? url.host ?? "Untitled" : state.title
        )
        if !bookmarks.contains(where: { $0.url == url }) {
            bookmarks.append(bookmark)
        }
    }

    public func removeBookmark(_ bookmark: Bookmark) {
        bookmarks.removeAll { $0.id == bookmark.id }
    }

    public func clearHistory() {
        history.removeAll()
    }

    // MARK: - Private

    private func addToHistory(_ url: URL) {
        if history.last != url {
            history.append(url)
        }
    }
}

// MARK: - Supporting Types

public struct Bookmark: Identifiable, Sendable, Codable {
    public let id: UUID
    public let url: URL
    public let title: String
    public let dateAdded: Date

    public init(
        id: UUID = UUID(),
        url: URL,
        title: String,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.dateAdded = dateAdded
    }
}
