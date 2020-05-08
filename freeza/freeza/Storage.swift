//
//  Storage.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case unexistentKey
    case incorrectType
}

protocol Storage {
    
    func save<ValueType>(value: ValueType, serializer: (ValueType) -> Any, for key: String)
    
    func load<ValueType>(key: String, deserializer: (Any) -> ValueType) -> Result<ValueType, StorageError>
    
}

extension Storage {
    
    func save<ValueType, Representable: RawRepresentable>(value: ValueType, serializer: (ValueType) -> Any, for key: Representable) where Representable.RawValue == String {
        return save(value: value, serializer: serializer, for: key.rawValue)
    }
    
    func load<ValueType, Representable: RawRepresentable>(key: Representable, deserializer: (Any) -> ValueType) -> Result<ValueType, StorageError> where Representable.RawValue == String {
        return load(key: key.rawValue, deserializer: deserializer)
    }
    
}


