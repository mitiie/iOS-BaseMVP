import UIKit

protocol MainRouting: AnyObject {
    func push(_ route: MainRoute, animated: Bool)
    func present(_ route: MainRoute, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension MainRouting {
    func push(_ route: MainRoute) {
        push(route, animated: true)
    }

    func present(_ route: MainRoute) {
        present(route, animated: true)
    }

    func pop() {
        pop(animated: true)
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func dismiss(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }

    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
}

final class MainRouter: MainRouting {
    private weak var navigationController: UINavigationController?
    private let builder: MainBuilder

    init(navigationController: UINavigationController, builder: MainBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func push(_ route: MainRoute, animated: Bool = true) {
        let viewController = builder.build(route: route, router: self)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func present(_ route: MainRoute, animated: Bool = true) {
        let viewController = builder.build(route: route, router: self)
        viewController.modalPresentationStyle = presentationStyle(for: route)
        navigationController?.topViewController?.present(viewController, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.topViewController?.dismiss(animated: animated, completion: completion)
    }

    private func presentationStyle(for route: MainRoute) -> UIModalPresentationStyle {
        switch route {
        case .detail:
            return .fullScreen
        case .iap:
            return .pageSheet
        }
    }
}
