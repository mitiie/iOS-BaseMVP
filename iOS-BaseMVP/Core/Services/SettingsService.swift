import Foundation

protocol SettingsServicing {
    func loadOptions() -> [SettingsOption]
}

final class LocalSettingsService: SettingsServicing {
    func loadOptions() -> [SettingsOption] {
        [
            SettingsOption(title: "Architecture", value: "MVP + Router + Builder"),
            SettingsOption(title: "Dependency Injection", value: "Initializer based"),
            SettingsOption(title: "Networking", value: "Alamofire base client")
        ]
    }
}
