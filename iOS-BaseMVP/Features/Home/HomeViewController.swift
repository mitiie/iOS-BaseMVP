import UIKit

final class HomeViewController: BaseViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    private let presenter: HomePresenter

    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @IBAction private func detailTapped() {
        presenter.openDetail()
    }

    @IBAction private func iapTapped() {
        presenter.openIAP()
    }
}

extension HomeViewController: HomePresenterDelegate {
    func homePresenterDidLoad(summary: HomeSummary) {
        titleLabel.text = summary.title
        subtitleLabel.text = summary.subtitle
    }
}
