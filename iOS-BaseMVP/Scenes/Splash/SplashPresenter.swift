import Foundation

final class SplashPresenter {
    private let router: AppRouting

    init(router: AppRouting) {
        self.router = router
    }

    func viewDidAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.router.setRoot(.onboarding)
        }
    }
}
