//
//  KeychainStorage.swift
//  Infrastructure
//
//  Created by Trung on 20/07/2021.
//

import Foundation
import KeychainAccess /// https://github.com/kishikawakatsumi/KeychainAccess

struct KeychainStorage {
    private let storage: Keychain
    
    init() {
        let bundleId = Bundle.main.bundleIdentifier!
        storage = Keychain(service: bundleId)
    }
    
    init(accessGroup: String) {
        storage = Keychain(accessGroup: accessGroup)
    }
    
    init(accessGroup: String, service: String) {
        storage = Keychain(service: service, accessGroup: accessGroup)
    }
}

extension KeychainStorage: KeyValueStorage {
    func remove(key: String) {
        try? storage.remove(key)
    }
    
    func contains(key: String) -> Bool {
        (try? storage.contains(key)) ?? false
    }
    
    func set<T>(_ value: T, key: String) where T : StoreAble {
        try? storage.set(value.encode(), key: key)
    }
    
    func get<T>(key: String, default: T) -> T where T : StoreAble {
        guard let string = try? storage.get(key) else { return `default` }
        return T.decode(string: string) ?? `default`
    }
    
    func get<T>(key: String) -> T? where T : StoreAble {
        guard let string = try? storage.get(key) else { return nil }
        return T.decode(string: string)
    }
}

private func sample() {
    let kc = KeychainStorage()
    kc.set(100, key: "id")
    let name = kc.get(key: "name", default: "Chon")
    print(name)
}
