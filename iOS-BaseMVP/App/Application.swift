import UIKit

final class Application {
    private let window: UIWindow
    private let container: AppContainer
    private let navigationController: UINavigationController
    private let router: CoreRouter

    init(window: UIWindow, container: AppContainer) {
        self.window = window
        self.container = container

        let navigationController = UINavigationController()
        let mainBuilder = MainBuilder(container: container)
        let mainRouter = MainRouter(navigationController: navigationController, builder: mainBuilder)
        let builder = CoreBuilder(container: container, mainBuilder: mainBuilder)
        let router = CoreRouter(
            navigationController: navigationController,
            builder: builder,
            mainRouter: mainRouter
        )

        self.navigationController = navigationController
        self.router = router
    }

    func start() {
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        router.setRoot(container.appSession.initialRoute, animated: false)
    }
}
