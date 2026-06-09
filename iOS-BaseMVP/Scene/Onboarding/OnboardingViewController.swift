import UIKit

final class OnboardingViewController: BaseController {
    @IBOutlet private weak var continueButton: UIButton!

    private let presenter: OnboardingPresenter

    init(presenter: OnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func continueTapped() {
        presenter.completeOnboarding()
    }
}

extension OnboardingViewController: OnboardingPresenterDelegate {
    func onboardingPresenterDidRequestLoading(_ isLoading: Bool) {
        continueButton.isEnabled = !isLoading
    }
}
