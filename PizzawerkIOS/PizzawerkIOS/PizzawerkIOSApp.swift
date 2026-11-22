import SwiftUI
import BackgroundTasks

@main
struct PizzawerkIOSApp: App {
    @Environment(\.scenePhase) private var scenePhase
    private let refreshTaskID = "de.pizzawerk.ios.refresh"

    init() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: refreshTaskID, using: nil) { task in
            guard let refreshTask = task as? BGAppRefreshTask else { return }
            RefreshManager.shared.handle(refreshTask)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active { RefreshManager.shared.refreshIfNeeded() }
            if phase == .background { RefreshManager.shared.scheduleNextRefresh() }
        }
    }
}
