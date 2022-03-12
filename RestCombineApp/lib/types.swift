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
    enum Body {
        case none
        case raw(String)
        case formData(RestParam)
        case formUrlEncoding(RestParam)
        
        func information() -> Information {
            switch(self) {
            case .none: return ["none": "-"]
            case let .raw(value): return ["raw": value]
            case let .formData(value): return ["formData": value]
            case let .formUrlEncoding(value): return ["urlEncoding": value]
            }
        }
    }
    
    enum Method: String {
        case get
        case post
        case put
        case delete
    }
    
    var baseUrl = ""
    var path = ""
    var method = Method.get
    var headers = RestHeader()
    var queries = RestParam()
    var body = Body.none
    
    func information() -> Information {
        return [:]
    }
    
    var fullUrl: String { [baseUrl, path].joinedBySplash }
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
