//
//  types.swift
//  RestCombineApp
//
//  Created by Trung on 12/03/2022.
//

import Foundation
import Combine

typealias RestParam = [String: Any]
typealias RestHeader = [String: Any]
typealias Information = [String: Any]

enum RestError: Error {
    case invalidRequest(Error?)
    case connectionFail(Error?)
    case internalError(Error?)
    case unknown(Error?)
}

enum ReceiveThread {
    case current
    case main
    
    var runLoop: RunLoop {
        switch(self) {
        case .current: return .current
        case .main: return .main
        }
    }
}

struct RestRequest {
    enum Method: String {
        case get
        case post
        case put
        case delete
    }
    
    let baseUrl: String
    let endPoint: String
    let method: Method
    let headers: RestHeader
    let queries: RestParam
    let bodyParams: RestParam
    
    func information() -> Information {
        return [:]
    }
    
    /// baseUrl + endPoint
    var fullUrl: String { [baseUrl, endPoint].joinedBySplash }
    
    /// baseUrl + endPoint + query
    var fullUrlWithQuery: String {
        var urlComponents = URLComponents(string: fullUrl)
        urlComponents?.queryItems = queries.map { .init(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url?.absoluteString ?? ""
    }
    
    init(
        method: Method,
        baseUrl: String,
        endPoint: String,
        defaultHeaders: RestHeader = .init(),
        defaultQueries: RestParam = .init(),
        defaultParams: RestParam = .init()
    ) {
        self.method = method
        self.baseUrl = baseUrl
        self.endPoint = endPoint
        self.headers = defaultHeaders
        self.queries = defaultQueries
        self.bodyParams = defaultParams
    }
    
    func appendingQueries(_ newOne: RestParam) -> Self {
        .init(
            method: method,
            baseUrl: baseUrl,
            endPoint: endPoint,
            defaultHeaders: headers,
            defaultQueries: queries.mergingAndReplacing(newDict: newOne),
            defaultParams: bodyParams
        )
    }
    
    func appendingHeaders(_ newOne: RestParam) -> Self {
        .init(
            method: method,
            baseUrl: baseUrl,
            endPoint: endPoint,
            defaultHeaders: headers.mergingAndReplacing(newDict: newOne),
            defaultQueries: queries,
            defaultParams: bodyParams
        )
    }
    
    func appendingParams(_ newOne: RestParam) -> Self {
        .init(
            method: method,
            baseUrl: baseUrl,
            endPoint: endPoint,
            defaultHeaders: headers,
            defaultQueries: queries,
            defaultParams: bodyParams.mergingAndReplacing(newDict: newOne)
        )
    }
}

struct RestResponse {
    let request: RestRequest
    let error: RestError?
    let data: Data?
    
    init(data: Data, request: RestRequest) {
        self.data = data
        self.request = request
        self.error = nil
    }
    
    init(error: RestError, request: RestRequest) {
        self.error = error
        self.request = request
        self.data = nil
    }
}

protocol ApiClient {
    func send(request: RestRequest) -> Future<RestResponse, Never>
}
