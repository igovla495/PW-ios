import SwiftUI
import WebKit

extension Notification.Name {
    static let pizzawerkRefresh = Notification.Name("pizzawerkRefresh")
}

final class WebViewModel: ObservableObject {
    let webView: WKWebView

    init() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        load("https://www.das-pizzawerk.de/startseite")
    }

    func load(_ address: String) {
        guard let url = URL(string: address) else { return }
        webView.load(URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData))
    }

    func reloadIgnoringCache() {
        guard let url = webView.url ?? URL(string: "https://www.das-pizzawerk.de/startseite") else { return }
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var model: WebViewModel
    func makeUIView(context: Context) -> WKWebView { model.webView }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
