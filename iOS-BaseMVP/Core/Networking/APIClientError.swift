import Foundation

enum APIClientError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int, data: Data?)
    case decoding(Error)
    case underlying(Error)
}

extension APIClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .statusCode(let statusCode, _):
            return "The server returned status code \(statusCode)."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
