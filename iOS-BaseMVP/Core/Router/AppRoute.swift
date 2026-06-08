import Foundation

enum AppRoute: Hashable {
    case splash
    case onboarding
    case main
}

enum MainRoute: Hashable {
    case detail(DetailContext)
    case iap(source: IAPSource)
}

enum MainTab: CaseIterable, Hashable {
    case home
    case setting

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .setting:
            return "Setting"
        }
    }
}

struct DetailContext: Hashable {
    let title: String
    let message: String
}

enum IAPSource: Hashable {
    case onboarding
    case setting
    case home

    var title: String {
        switch self {
        case .onboarding:
            return "Onboarding"
        case .setting:
            return "Setting"
        case .home:
            return "Home"
        }
    }
}
