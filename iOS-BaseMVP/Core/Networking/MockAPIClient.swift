import Foundation

final class MockAPIClient: APIClientProtocol {
    typealias Handler = (APIEndpoint) async throws -> Data

    private let handler: Handler
    private let decoder: JSONDecoder

    init(
        decoder: JSONDecoder = JSONDecoder(),
        handler: @escaping Handler
    ) {
        self.decoder = decoder
        self.handler = handler
    }

    func request<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response {
        let data = try await handler(endpoint)
        return try decoder.decode(Response.self, from: data)
    }

    func requestData(_ endpoint: APIEndpoint) async throws -> Data {
        try await handler(endpoint)
    }
}
