/// @author Dambert Muñoz
/// Tests for WebContentUseCase

import Foundation
import Testing
@testable import NativeWebView

@Suite("WebContentUseCase Tests")
struct WebContentUseCaseTests {
    let useCase = WebContentUseCase()

    @Test("Valid URL passes validation")
    func testValidURL() {
        let result = useCase.validateURL("https://apple.com")
        #expect(result == .success(URL(string: "https://apple.com")!))
    }

    @Test("URL without scheme gets https added")
    func testURLWithoutScheme() {
        let result = useCase.validateURL("apple.com")
        if case .success(let url) = result {
            #expect(url.absoluteString == "https://apple.com")
        } else {
            Issue.record("Expected success")
        }
    }

    @Test("Blocked domains are rejected", arguments: [
        "blocked.com",
        "www.blocked.com",
        "sub.blocked.com"
    ])
    func testBlockedDomains(domain: String) {
        let url = URL(string: "https://\(domain)")!
        let result = useCase.shouldAllowNavigation(to: url, blockedDomains: ["blocked.com"])
        #expect(!result)
    }

    @Test("Allowed domains pass")
    func testAllowedDomains() {
        let url = URL(string: "https://apple.com")!
        let result = useCase.shouldAllowNavigation(to: url, blockedDomains: ["blocked.com"])
        #expect(result)
    }

    @Test("Extract domain from URL")
    func testExtractDomain() {
        let url = URL(string: "https://www.apple.com/iphone")!
        let domain = useCase.extractDomain(from: url)
        #expect(domain == "www.apple.com")
    }
}

@Suite("URL Validation Extensions")
struct URLValidationTests {

    @Test("HTTPS URLs are secure")
    func testSecureURL() {
        let url = URL(string: "https://apple.com")!
        #expect(url.isSecure)
    }

    @Test("HTTP URLs are not secure")
    func testInsecureURL() {
        let url = URL(string: "http://example.com")!
        #expect(!url.isSecure)
    }

    @Test("Display host removes www prefix")
    func testDisplayHost() {
        let url = URL(string: "https://www.apple.com")!
        #expect(url.displayHost == "apple.com")
    }

    @Test("Search query creates search URL")
    func testSearchQuery() {
        let url = URL.fromSearchOrURL("swift programming", searchEngine: .google)
        #expect(url?.host == "www.google.com")
        #expect(url?.absoluteString.contains("swift%20programming") == true)
    }
}
