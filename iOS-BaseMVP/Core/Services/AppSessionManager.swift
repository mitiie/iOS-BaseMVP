import Combine
import Foundation

protocol AppSessionManaging: AnyObject {
    var initialRoute: AppRoute { get }
    var hasCompletedOnboarding: Bool { get }
    var hasPremiumAccess: Bool { get }
    func markOnboardingCompleted()
    func markPurchasedSuccessfully()
    func resetOnboarding()
    func resetPremiumAccess()
}

final class AppSessionManager: AppSessionManaging {
    private let defaults: UserDefaults
    private let onboardingKey = "com.ios-base-mvp.hasCompletedOnboarding"
    private let premiumKey = "com.ios-base-mvp.hasPremiumAccess"
    private var cancellables = Set<AnyCancellable>()

    init(defaults: UserDefaults = .standard, appEventBus: AppEventObserving? = nil) {
        self.defaults = defaults
        appEventBus?.events
            .sink { [weak self] event in
                switch event {
                case .onboardingCompleted:
                    self?.markOnboardingCompleted()
                case .purchasedSuccessfully:
                    self?.markPurchasedSuccessfully()
                }
            }
            .store(in: &cancellables)
    }

    var initialRoute: AppRoute {
        hasCompletedOnboarding ? .main : .splash
    }

    var hasCompletedOnboarding: Bool {
        defaults.bool(forKey: onboardingKey)
    }

    var hasPremiumAccess: Bool {
        defaults.bool(forKey: premiumKey)
    }

    func markOnboardingCompleted() {
        defaults.set(true, forKey: onboardingKey)
    }

    func markPurchasedSuccessfully() {
        defaults.set(true, forKey: premiumKey)
    }

    func resetOnboarding() {
        defaults.set(false, forKey: onboardingKey)
    }

    func resetPremiumAccess() {
        defaults.set(false, forKey: premiumKey)
    }
}
