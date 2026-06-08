import Foundation

protocol DetailPresenterDelegate: AnyObject {
    func detailPresenterDidLoad(context: DetailContext)
}

final class DetailPresenter {
    weak var delegate: DetailPresenterDelegate?

    private let router: MainRouting
    private let context: DetailContext

    init(router: MainRouting, context: DetailContext) {
        self.router = router
        self.context = context
    }

    func viewDidLoad() {
        delegate?.detailPresenterDidLoad(context: context)
    }

    func goBack() {
        router.pop()
    }
}
