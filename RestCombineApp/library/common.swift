//
//  common.swift
//  RestCombineApp
//
//  Created by Trung on 27/03/2022.
//

import Foundation

func parsing<T: Decodable>(_ data: Data?, to type: T.Type) -> T? {
    guard let data = data else { return nil }
    let decoder = JSONDecoder()
    return try? decoder.decode(type, from: data)
}

public extension Array {
    subscript(at index: Int) -> Element? {
        let isOutOfRange = index < 0 || index >= count
        return isOutOfRange ? nil : self[index]
    }
    
    func element(at index: Int) -> Element? {
        let isOutOfRange = index < 0 || index >= count
        return isOutOfRange ? nil : self[index]
    }
}
