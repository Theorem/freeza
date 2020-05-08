//
//  UserDefaults+Storage.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

extension UserDefaults: Storage {
    
    func save<ValueType>(value: ValueType, serializer: (ValueType) -> Any, for key: String) {
        setValue(value, forKey: key)
    }
    
    func load<ValueType>(key: String, deserializer: (Any) -> ValueType) -> Result<ValueType, StorageError> {
        guard let value = self.value(forKey: key) else {
            print("Value for key \(key) does not exists")
            return Result.failure(StorageError.unexistentKey)
        }
        
        guard let castedValue = value as? ValueType else {
            print("Incorrect type of value for key \(key)")
            return Result.failure(StorageError.incorrectType)
        }
        
        return Result.success(castedValue)
    }
}
