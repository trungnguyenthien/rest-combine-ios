//
//  ValueEncodable.swift
//  Infrastructure
//
//  Created by Trung on 22/07/2021.
//

import Foundation

public protocol StoreAble {
    func encode() -> String
    static func decode(string: String) -> Self?
}

extension StoreAble {
    public func encode() -> String {
        toBase64(self)
    }
    
    public static func decode(string: String) -> Self? {
        fromBase64(string, Self.self)
    }
}

public protocol KeyValueStorage {
    func contains(key: String) -> Bool
    func set<T: StoreAble>(_ value: T, key: String)
    func get<T: StoreAble>(key: String, default: T) -> T
    func get<T: StoreAble>(key: String) -> T?
    func remove(key: String)
}

extension Int: StoreAble {}
extension String: StoreAble {}
extension Bool: StoreAble {}
extension Double: StoreAble {}
extension Float: StoreAble {}
