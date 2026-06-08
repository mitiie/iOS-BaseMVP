import Alamofire
import Foundation

final class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.ios-base-mvp.network-logger")

    func requestDidResume(_ request: Request) {
        #if DEBUG
        let method = request.request?.httpMethod ?? "UNKNOWN"
        let url = request.request?.url?.absoluteString ?? "unknown-url"
        print("-> [API] \(method) \(url)")
        #endif
    }

    func request<Value: Sendable>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        #if DEBUG
        let method = request.request?.httpMethod ?? "UNKNOWN"
        let url = request.request?.url?.absoluteString ?? "unknown-url"
        let statusCode = response.response?.statusCode.description ?? "no-status"
        print("<- [API] \(method) \(url) - \(statusCode)")
        #endif
    }
}
