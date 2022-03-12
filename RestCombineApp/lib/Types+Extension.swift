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
}

extension Sequence where Element == String {
    var joinedBySplash: String {
        let splashChar = "/"
        let splashCharSet = CharacterSet(charactersIn: splashChar)
        return map { $0.trimmingCharacters(in: splashCharSet) }.joined(separator: splashChar)
    }
}
