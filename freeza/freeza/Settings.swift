//
//  Settings.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

class Settings {
    
    enum Key: String, CaseIterable {
        case filterNSFWContent
    }
    
    fileprivate let _storage: Storage

    var allSetings: [Settings.Key] {
        return Key.allCases
    }
    
    init(storage: Storage) {
        _storage = storage
    }
    
    subscript<T>(key: Key) -> T? {
        get {
            return try? _storage.load(key: key, deserializer: { $0 as! T }).get()
        }
        set {
            _storage.save(value: newValue, serializer: { $0 as Any }, for: key)
        }
    }
    
}
