//
//  NetworkService.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Alamofire

enum FetchResult<Success, GeneralError> {
    case success(Success)
    case failure(GeneralError)
}

protocol IEndpoint {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

enum NetworkStatus {
    static var isInternetAvailable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class NetworkService {
    static let share = NetworkService()
    private var dataRequest: DataRequest?

    @discardableResult
    private func _dataRequest(endpoint: IEndpoint) -> DataRequest {
        return AF.request(endpoint.url,
                          method: endpoint.method,
                          parameters: endpoint.parameters,
                          encoding: endpoint.encoding,
                          headers: endpoint.headers)
    }

    func request<T: Decodable>(endpoint: IEndpoint, completion: @escaping (FetchResult<T, String>) -> Void) {
        guard NetworkStatus.isInternetAvailable else {
            completion(.failure(Messages.generalError))
            return
        }

        DispatchQueue.global(qos: .background).async {
            self.dataRequest = self._dataRequest(endpoint: endpoint)
            self.dataRequest?.validate().responseDecodable(decoder: jsonDecoder()) {
                (response: AFDataResponse<T>) in
                TRACER(endpoint, response)
                
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure:
                    completion(.failure(Messages.generalError))
                }
            }
        }
    }
}

public func jsonDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

private func TRACER<T: Any>(_ endpoint: IEndpoint, _ response: AFDataResponse<T>) {
    #if DEBUG
    let duration = response.metrics?.taskInterval.duration ?? 0
    let seconds = (duration * 10000).rounded() / 10000

    let trace = """
    --------------------------TRACING START-------------------------
    [REQUEST]: \(endpoint.method.rawValue) \(endpoint.url) '\(seconds)s'

    [HEADERS]: \(endpoint.headers == nil ? "-" : "\n" + (endpoint.headers!.dictionary.toJSON!))

    [ENCODING]: \(endpoint.encoding)

    [PARAMETERS]: \(endpoint.parameters == nil ? "-" : "\n" + (endpoint.parameters!.toJSON!))

    [RESPONSE]: \(response.data?.toJSON == nil ? "-" : "\n" + response.data!.toJSON!)
    --------------------------TRACING STOP--------------------------
    """
    print(trace.removeBackslash)
    #endif
}
