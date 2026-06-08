import Foundation

final class AppContainer {
    lazy var appEventBus: AppEventBus = AppEventBus()
    lazy var appSession: AppSessionManaging = AppSessionManager(appEventBus: appEventBus)
    lazy var homeDataProvider: HomeDataProviding = LocalHomeDataProvider()
    lazy var settingsService: SettingsServicing = LocalSettingsService()
    lazy var apiClient: APIClientProtocol = AlamofireAPIClient(configuration: .default)
}
