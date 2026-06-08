import Alamofire
import Foundation

final class AlamofireAPIClient: APIClientProtocol {
    private let configuration: APIConfiguration
    private let session: Session
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        configuration: APIConfiguration = .default,
        session: Session? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.configuration = configuration
        self.decoder = decoder
        self.encoder = encoder
        self.session = session ?? Session(eventMonitors: [NetworkLogger()])
    }

    func request<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response {
        let apiRequest = APIRequest(endpoint: endpoint, configuration: configuration, encoder: encoder)
        let response = await session
            .request(apiRequest)
            .validate(statusCode: 200..<300)
            .serializingDecodable(Response.self, decoder: decoder)
            .response

        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw mapError(error, response: response.response, data: response.data)
        }
    }

    func requestData(_ endpoint: APIEndpoint) async throws -> Data {
        let apiRequest = APIRequest(endpoint: endpoint, configuration: configuration, encoder: encoder)
        let response = await session
            .request(apiRequest)
            .validate(statusCode: 200..<300)
            .serializingData()
            .response

        switch response.result {
        case .success(let data):
            return data
        case .failure(let error):
            throw mapError(error, response: response.response, data: response.data)
        }
    }

    private func mapError(_ error: AFError, response: HTTPURLResponse?, data: Data?) -> APIClientError {
        if let statusCode = response?.statusCode {
            return .statusCode(statusCode, data: data)
        }

        if case .responseSerializationFailed = error {
            return .decoding(error)
        }

        return .underlying(error)
    }
}
