//
//  Types+Extension.swift
//  RestCombineApp
//
//  Created by Trung on 12/03/2022.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    /// Merge and repalce by new value
    static func += <K, V> (left: inout [K: V], right: [K: V]) {
        for (k, v) in right {
            left[k] = v
        }
    }
    
    func mergingAndReplacing(newDict: Self) -> Self {
        merging(newDict, uniquingKeysWith: { _, new in new })
    }
}

extension Sequence where Element == String {
    var joinedBySplash: String {
        let splashChar = "/"
        let splashCharSet = CharacterSet(charactersIn: splashChar)
        return map { $0.trimmingCharacters(in: splashCharSet) }
            .joined(separator: splashChar)
    }
}

func parsing<T: Decodable>(_ data: Data?, to type: T.Type) -> T? {
    guard let data = data else { return nil }
    let decoder = JSONDecoder()
    return try? decoder.decode(type, from: data)
}


