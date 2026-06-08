import UIKit

final class IAPViewController: BaseViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    private let presenter: IAPPresenter

    init(presenter: IAPPresenter) {
        self.presenter = presenter
        super.init(nibName: "IAPViewController", bundle: nil)
        self.presenter.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @IBAction private func closeTapped() {
        presenter.close()
    }

    @IBAction private func purchaseTapped() {
        presenter.completePurchase()
    }
}

extension IAPViewController: IAPPresenterDelegate {
    func iapPresenterDidLoad(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
}
