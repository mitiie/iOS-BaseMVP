import UIKit

final class CoreBuilder {
    private let container: AppContainer
    private let mainBuilder: MainBuilder

    init(container: AppContainer, mainBuilder: MainBuilder) {
        self.container = container
        self.mainBuilder = mainBuilder
    }

    func build(route: AppRoute, appRouter: AppRouting, mainRouter: MainRouting) -> UIViewController {
        switch route {
        case .splash:
            let presenter = SplashPresenter(router: appRouter)
            return SplashViewController(presenter: presenter)

        case .onboarding:
            let presenter = OnboardingPresenter(router: appRouter, appEventBus: container.appEventBus)
            return OnboardingViewController(presenter: presenter)

        case .main:
            let presenter = MainPresenter(tabs: MainTab.allCases)
            let mainController = MainController(presenter: presenter)
            let tabViewControllers = MainTab.allCases.map { mainBuilder.buildTab($0, router: mainRouter) }
            mainController.setViewControllers(tabViewControllers, animated: false)
            return mainController
        }
    }
}
