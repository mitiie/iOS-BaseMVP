import UIKit

protocol AppRouting: AnyObject {
    func setRoot(_ route: AppRoute, animated: Bool)
}

extension AppRouting {
    func setRoot(_ route: AppRoute) {
        setRoot(route, animated: true)
    }
}

final class CoreRouter: AppRouting {
    private weak var navigationController: UINavigationController?
    private let builder: CoreBuilder
    private let mainRouter: MainRouting

    init(navigationController: UINavigationController, builder: CoreBuilder, mainRouter: MainRouting) {
        self.navigationController = navigationController
        self.builder = builder
        self.mainRouter = mainRouter
    }

    func setRoot(_ route: AppRoute, animated: Bool = true) {
        let viewController = builder.build(route: route, appRouter: self, mainRouter: mainRouter)
        navigationController?.setViewControllers([viewController], animated: animated)
    }
}
