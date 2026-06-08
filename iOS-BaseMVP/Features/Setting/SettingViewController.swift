import UIKit

final class SettingViewController: BaseViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstOptionLabel: UILabel!
    @IBOutlet private weak var secondOptionLabel: UILabel!
    @IBOutlet private weak var thirdOptionLabel: UILabel!

    private let presenter: SettingPresenter

    init(presenter: SettingPresenter) {
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

extension SettingViewController: SettingPresenterDelegate {
    func settingPresenterDidLoad(title: String, options: [SettingsOption]) {
        titleLabel.text = title

        let labels = [firstOptionLabel, secondOptionLabel, thirdOptionLabel]
        labels.enumerated().forEach { index, label in
            guard index < options.count else {
                label?.isHidden = true
                return
            }

            let option = options[index]
            label?.text = "\(option.title): \(option.value)"
            label?.isHidden = false
        }
    }
}
