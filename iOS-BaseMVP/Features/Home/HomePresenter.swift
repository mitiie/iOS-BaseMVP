import Foundation

protocol HomePresenterDelegate: AnyObject {
    func homePresenterDidLoad(summary: HomeSummary)
}

final class HomePresenter {
    weak var delegate: HomePresenterDelegate?

    private let router: MainRouting
    private let homeDataProvider: HomeDataProviding

    init(router: MainRouting, homeDataProvider: HomeDataProviding) {
        self.router = router
        self.homeDataProvider = homeDataProvider
    }

    func viewDidLoad() {
        delegate?.homePresenterDidLoad(summary: homeDataProvider.loadSummary())
    }

    func openDetail() {
        let context = DetailContext(
            title: "Home Detail",
            message: "This screen was pushed from Home tab through MainRoute.detail."
        )
        router.push(.detail(context))
    }

    func openIAP() {
        router.present(.iap(source: .home))
    }
}
