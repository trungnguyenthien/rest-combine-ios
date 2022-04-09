//
//  UserDefaultsStorage.swift
//  Infrastructure
//
//  Created by Trung on 22/07/2021.
//

import Foundation

struct UserDefaultsStorage {
    private let storage: UserDefaults
    
    init() {
        storage = .standard
    }
    
    init(name: String) {
        storage = .init(suiteName: name)!
    }
}

extension UserDefaultsStorage: KeyValueStorage {
    func remove(key: String) {
        storage.removeObject(forKey: key)
    }
    
    func contains(key: String) -> Bool {
        storage.object(forKey: key) != nil
    }
    
    func set<T>(_ value: T, key: String) where T : StoreAble {
        storage.setValue(value.encode(), forKey: key)
    }
    
    func get<T>(key: String, default: T) -> T where T : StoreAble {
        guard let string = storage.string(forKey: key) else { return `default`}
        return T.decode(string: string) ?? `default`
    }
    
    func get<T>(key: String) -> T? where T : StoreAble {
        guard let string = storage.string(forKey: key) else { return nil}
        return T.decode(string: string)
    }
}
