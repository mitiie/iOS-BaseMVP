import Foundation

protocol OnboardingPresenterDelegate: AnyObject {
    func onboardingPresenterDidRequestLoading(_ isLoading: Bool)
}

final class OnboardingPresenter {
    weak var delegate: OnboardingPresenterDelegate?

    private let router: AppRouting
    private let appEventBus: AppEventSending

    init(router: AppRouting, appEventBus: AppEventSending) {
        self.router = router
        self.appEventBus = appEventBus
    }

    func completeOnboarding() {
        delegate?.onboardingPresenterDidRequestLoading(true)
        appEventBus.send(.onboardingCompleted)
        router.setRoot(.main)
    }
}
