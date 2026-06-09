import Foundation

protocol SettingPresenterDelegate: AnyObject {
    func settingPresenterDidLoad(title: String, options: [SettingsOption])
}

final class SettingPresenter {
    weak var delegate: SettingPresenterDelegate?

    private let router: MainRouting
    private let settingsService: SettingsServicing

    init(router: MainRouting, settingsService: SettingsServicing) {
        self.router = router
        self.settingsService = settingsService
    }

    func viewDidLoad() {
        delegate?.settingPresenterDidLoad(title: "Setting", options: settingsService.loadOptions())
    }

    func openDetail() {
        let context = DetailContext(
            title: "Setting Detail",
            message: "This screen was pushed from Setting tab through MainRoute.detail."
        )
        router.push(.detail(context))
    }

    func openIAP() {
        router.present(.iap(source: .setting))
    }
}
