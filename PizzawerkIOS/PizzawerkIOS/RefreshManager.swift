import Foundation
import BackgroundTasks

final class RefreshManager {
    static let shared = RefreshManager()
    private let taskID = "de.pizzawerk.ios.refresh"
    private let lastRefreshKey = "lastRefresh"

    func refreshIfNeeded() {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 10
        let todayAtTen = calendar.date(from: components) ?? now
        let last = UserDefaults.standard.object(forKey: lastRefreshKey) as? Date ?? .distantPast
        if now >= todayAtTen && last < todayAtTen { performRefresh() }
    }

    func scheduleNextRefresh() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskID)
        let request = BGAppRefreshTaskRequest(identifier: taskID)
        request.earliestBeginDate = nextTenOClock()
        try? BGTaskScheduler.shared.submit(request)
    }

    func handle(_ task: BGAppRefreshTask) {
        scheduleNextRefresh()
        task.expirationHandler = { task.setTaskCompleted(success: false) }
        performRefresh()
        task.setTaskCompleted(success: true)
    }

    private func performRefresh() {
        UserDefaults.standard.set(Date(), forKey: lastRefreshKey)
        NotificationCenter.default.post(name: .pizzawerkRefresh, object: nil)
    }

    private func nextTenOClock() -> Date {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 10
        let today = calendar.date(from: components) ?? now
        return today > now ? today : calendar.date(byAdding: .day, value: 1, to: today) ?? now.addingTimeInterval(86400)
    }
}
