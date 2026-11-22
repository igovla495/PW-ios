import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var model = WebViewModel()
    @State private var sheet: AppSheet?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                Color.black.frame(height: 32)

                WebView(model: model)
                    .background(Color.white)

                HStack(spacing: 0) {
                    navButton("START") { model.load("https://www.das-pizzawerk.de/startseite") }
                    navButton("KARTEN") { sheet = .menus }
                    navButton("STANDORTE") { sheet = .locations }
                    navButton("SOCIAL") { sheet = .social }
                }
                .frame(height: 58)
                .background(Color.black)

                Color.black.frame(height: 16)
            }
        }
        .sheet(item: $sheet) { selected in
            NavigationStack {
                SelectionList(type: selected) { url in
                    sheet = nil
                    if url.host?.contains("das-pizzawerk.de") == true {
                        model.load(url.absoluteString)
                    } else {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
        .onReceive(NotificationCenter.default.publisher(for: .pizzawerkRefresh)) { _ in
            model.reloadIgnoringCache()
        }
    }

    private func navButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

enum AppSheet: String, Identifiable {
    case menus, locations, social
    var id: String { rawValue }
}

struct SelectionList: View {
    let type: AppSheet
    let select: (URL) -> Void

    private var title: String {
        switch type { case .menus: "Menükarten"; case .locations: "Standorte"; case .social: "Social Media" }
    }

    private var entries: [(String, String)] {
        switch type {
        case .menus:
            return [("Pizza", "/pizza"), ("Pasta", "/pasta"), ("Vorspeisen", "/vorspeisen"), ("Salate", "/salate"), ("Saltimbocca", "/saltimbocca"), ("Getränke", "/getraenke"), ("Desserts", "/desserts")]
        case .locations:
            return [("Alle Standorte", "/standorte"), ("Daimlerstraße 5a", "/standort-braunschweig-daimlerstrasse"), ("Botanischer Garten · Bültenweg 95a", "/standort-braunschweig-bueltenweg"), ("Schmalbachstraße 4", "/standort-braunschweig-schmalbachstrasse")]
        case .social:
            return [("Instagram", "https://www.instagram.com/daspizzawerk/"), ("Facebook", "https://www.facebook.com/daspizzawerk/")]
        }
    }

    var body: some View {
        List(entries, id: \.0) { item in
            Button(item.0) {
                let value = item.1.hasPrefix("http") ? item.1 : "https://www.das-pizzawerk.de\(item.1)"
                if let url = URL(string: value) { select(url) }
            }
        }
        .navigationTitle(title)
    }
}
