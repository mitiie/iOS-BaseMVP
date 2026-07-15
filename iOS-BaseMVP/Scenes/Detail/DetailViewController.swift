import UIKit

final class DetailViewController: BaseController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    private let presenter: DetailPresenter

    init(presenter: DetailPresenter) {
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

    @IBAction private func backTapped() {
        presenter.goBack()
    }
}

extension DetailViewController: DetailPresenterDelegate {
    func detailPresenterDidLoad(context: DetailContext) {
        titleLabel.text = context.title
        messageLabel.text = context.message
    }
}
