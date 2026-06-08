import UIKit

final class MainBuilder {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    func buildTab(_ tab: MainTab, router: MainRouting) -> UIViewController {
        switch tab {
        case .home:
            let presenter = HomePresenter(router: router, homeDataProvider: container.homeDataProvider)
            let viewController = HomeViewController(presenter: presenter)
            viewController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
            return viewController

        case .setting:
            let presenter = SettingPresenter(
                router: router,
                settingsService: container.settingsService
            )
            let viewController = SettingViewController(presenter: presenter)
            viewController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: UIImage(systemName: "gearshape"),
                selectedImage: UIImage(systemName: "gearshape.fill")
            )
            return viewController
        }
    }

    func build(route: MainRoute, router: MainRouting) -> UIViewController {
        switch route {
        case .detail(let context):
            let presenter = DetailPresenter(router: router, context: context)
            return DetailViewController(presenter: presenter)
        case .iap(let source):
            let presenter = IAPPresenter(router: router, source: source, appEventBus: container.appEventBus)
            return IAPViewController(presenter: presenter)
        }
    }
}
