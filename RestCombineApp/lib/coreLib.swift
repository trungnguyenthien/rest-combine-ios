//
//  coreLib.swift
//  RestCombineApp
//
//  Created by Trung on 12/03/2022.
//

import Foundation
import Alamofire
import Combine

///https://codewithchris.com/alamofire/
func send(request: RestRequest) -> Future<RestResponse, Never> {
    return Future { promise in
        func complete(data: Data? = nil, error: RestError? = nil) {
            if let data = data {
                let result = RestResponse(data: data, request: request)
                promise(.success(result))
            } else if let error = error {
                let result = RestResponse(error: error, request: request)
                promise(.success(result))
            }
        }
        makeAFRequest(request: request).response {
            if let error = $0.error?.restError {
                complete(error: error)
            } else if let data = $0.data {
                complete(data: data)
            }
        }
    }
}

private func makeAFRequest(request: RestRequest) -> DataRequest {
    let headers = HTTPHeaders(request.headers.map {
        HTTPHeader(name: $0.key, value: "\($0.value)")
    })
    
    let method = request.method.httpMethod
    
    var queries = [String: String]()
    request.queries.forEach { queries[$0.key] = "\($0.value)" }
    
    switch(request.method) {
    case .get, .delete:
        return AF.request(
            request.fullUrl,
            method: method,
            parameters: queries,
            encoder: .urlEncodedForm,
            headers: headers,
            interceptor: nil,
            requestModifier: nil
        )
    case .post, .put:
        return AF.request(
            request.fullUrl,
            method: method,
            parameters: queries,
            encoder: .urlEncodedForm,
            headers: headers,
            interceptor: nil,
            requestModifier: nil
        )
    }
}

private extension AFError {
    var restError: RestError {
        switch(self) {
        case .createUploadableFailed(let error), .createURLRequestFailed(error: let error):
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
