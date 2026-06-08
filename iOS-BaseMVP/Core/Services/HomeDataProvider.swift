import Foundation

protocol HomeDataProviding {
    func loadSummary() -> HomeSummary
}

final class LocalHomeDataProvider: HomeDataProviding {
    func loadSummary() -> HomeSummary {
        HomeSummary(
            title: "MVP Base Ready",
            subtitle: "Splash, Onboarding, MainController tabs, Router, Builder, DI, and XIB are wired."
        )
    }
}
