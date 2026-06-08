import Foundation

protocol IAPPresenterDelegate: AnyObject {
    func iapPresenterDidLoad(title: String, message: String)
}

final class IAPPresenter {
    weak var delegate: IAPPresenterDelegate?

    private let router: MainRouting
    private let source: IAPSource
    private let appEventBus: AppEventSending

    init(router: MainRouting, source: IAPSource, appEventBus: AppEventSending) {
        self.router = router
        self.source = source
        self.appEventBus = appEventBus
    }

    func viewDidLoad() {
        delegate?.iapPresenterDidLoad(
            title: "In-App Purchase",
            message: makeMessage(for: source)
        )
    }

    func close() {
        router.dismiss()
    }

    func completePurchase() {
        appEventBus.send(.purchasedSuccessfully(source: source))
        router.dismiss()
    }

    private func makeMessage(for source: IAPSource) -> String {
        switch source {
        case .onboarding:
            return "This paywall is presented from Onboarding. After a purchase, the app can continue the onboarding flow."
        case .setting:
            return "This paywall is presented from Setting. It is useful when users upgrade from a stable settings entry point."
        case .home:
            return "This paywall is presented from Home. It is useful when users hit premium content from the main experience."
        }
    }
}
