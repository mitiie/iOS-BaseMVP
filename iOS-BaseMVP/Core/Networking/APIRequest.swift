import Alamofire
import Foundation

struct APIRequest: URLRequestConvertible, @unchecked Sendable {
    private let endpoint: APIEndpoint
    private let configuration: APIConfiguration
    private let encoder: JSONEncoder

    init(
        endpoint: APIEndpoint,
        configuration: APIConfiguration,
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.endpoint = endpoint
        self.configuration = configuration
        self.encoder = encoder
    }

    func asURLRequest() throws -> URLRequest {
        let trimmedPath = endpoint.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        var url = configuration.baseURL.appendingPathComponent(trimmedPath)

        if !endpoint.queryItems.isEmpty {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw APIClientError.invalidURL
            }
            components.queryItems = endpoint.queryItems
            guard let composedURL = components.url else {
                throw APIClientError.invalidURL
            }
            url = composedURL
        }

        var request = URLRequest(url: url)
        request.method = HTTPMethod(rawValue: endpoint.method.rawValue)
        request.timeoutInterval = configuration.timeoutInterval

        let headers = configuration.defaultHeaders.merging(endpoint.headers) { _, endpointValue in endpointValue }
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        switch endpoint.body {
        case .none:
            return request

        case .encodable(let value):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try encoder.encode(value)
            return request

        case .parameters(let parameters, let encoding):
            switch encoding {
            case .json:
                return try JSONEncoding.default.encode(request, with: parameters)
            case .urlEncoded:
                return try URLEncoding.httpBody.encode(request, with: parameters)
            }

        case .data(let data, let contentType):
            if let contentType {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = data
            return request
        }
    }
}
