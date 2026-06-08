import Foundation

protocol APIClientProtocol {
    func request<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response
    func requestData(_ endpoint: APIEndpoint) async throws -> Data
}

extension APIClientProtocol {
    func requestVoid(_ endpoint: APIEndpoint) async throws {
        let _: EmptyAPIResponse = try await request(endpoint)
    }
}

struct EmptyAPIResponse: Decodable {}
