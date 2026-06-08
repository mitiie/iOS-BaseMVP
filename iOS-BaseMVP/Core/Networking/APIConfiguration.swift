import Foundation

struct APIConfiguration {
    let baseURL: URL
    let defaultHeaders: [String: String]
    let timeoutInterval: TimeInterval

    init(
        baseURL: URL,
        defaultHeaders: [String: String] = [:],
        timeoutInterval: TimeInterval = 30
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeoutInterval = timeoutInterval
    }

    static let `default` = APIConfiguration(
        baseURL: URL(string: "https://api.example.com")!,
        defaultHeaders: [
            "Accept": "application/json"
        ]
    )
}
