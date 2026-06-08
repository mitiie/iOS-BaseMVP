import Foundation

protocol APIEndpoint {
    var path: String { get }
    var method: APIHTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: APIRequestBody { get }
}

extension APIEndpoint {
    var method: APIHTTPMethod { .get }
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    var body: APIRequestBody { .none }
}

enum APIHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIParameterEncoding {
    case json
    case urlEncoded
}

enum APIRequestBody {
    case none
    case encodable(AnyEncodable)
    case parameters([String: Any], encoding: APIParameterEncoding)
    case data(Data, contentType: String?)

    static func json<T: Encodable>(_ value: T) -> APIRequestBody {
        .encodable(AnyEncodable(value))
    }
}

struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        self.encodeClosure = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
