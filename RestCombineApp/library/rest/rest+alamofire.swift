import Foundation
import Alamofire ///https://codewithchris.com/alamofire/
import Combine

class AlamofireApiClient: ApiClient {
    func send(request: RestRequest) -> Future<RestResponse, Never> {
        Future { result in
            func complete(code: Int, data: Data? = nil, error: RestError? = nil) {
                if let data = data {
                    let response = RestResponse(data: data, code: code, request: request)
                    result(.success(response))
                } else if let error = error {
                    let response = RestResponse(error: error, code: code, request: request)
                    result(.success(response))
                }
            }
            makeAFRequest(request: request).response {
                let code = $0.response?.statusCode ?? -1
                if let error = $0.error?.restError {
                    complete(code: code, error: error)
                } else if let data = $0.data {
                    complete(code: code, data: data)
                } else {
                    complete(code: code, error: .unknown(nil))
                }
            }
        }
    }
}

private func makeAFRequest(request: RestRequest) -> DataRequest {
    switch(request.method) {
    case .get, .delete:
        return AF.request(
            request.fullUrl,
            method: request.method.httpMethod,
            parameters: request.queries.stringDict,
            encoder: .urlEncodedForm,
            headers: request.headers.httpHeaders,
            interceptor: nil,
            requestModifier: nil
        )
    case .post, .put:
        return AF.request(
            request.fullUrlWithQuery,
            method: request.method.httpMethod,
            parameters: request.bodyParams.stringDict,
            encoding: URLEncoding(destination: .httpBody),
            headers: request.headers.httpHeaders,
            interceptor: nil,
            requestModifier: nil
        )
    }
}

private extension AFError {
    var restError: RestError {
        switch(self) {
        case .createUploadableFailed(let error),
            .createURLRequestFailed(error: let error):
            return .invalidRequest(error)
            
        case .downloadedFileMoveFailed(error: let error):
            return .internalError(error.error)
            
        case .explicitlyCancelled,
            .sessionDeinitialized:
            return .connectionFail(nil)
            
        case .invalidURL,
            .multipartEncodingFailed,
            .parameterEncodingFailed,
            .parameterEncoderFailed,
            .urlRequestValidationFailed:
            return .invalidRequest(nil)
            
        case .sessionInvalidated(error: let error):
            return .connectionFail(error)
            
        case .sessionTaskFailed(error: let error):
            return .connectionFail(error)
            
        default:
            return .unknown(nil)
        }
    }
}

private extension RestRequest.Method {
    var httpMethod: HTTPMethod {
        switch(self) {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return.delete
        }
    }
}

private extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var stringDict: [String: String] {
        var output = [String: String]()
        forEach { output["\($0.key)"] = "\($0.value)" }
        return output
    }
    
    var httpHeaders: HTTPHeaders {
        HTTPHeaders( map { .init(
            name: "\($0.key)",
            value: "\($0.value)"
        )})
    }
}
