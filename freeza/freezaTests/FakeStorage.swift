//
//  FakeStorage.swift
//  freezaTests
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

@testable import freeza
import Foundation

class FakeStorage: Storage {

    var fakedLoadResponse: Result<Any, StorageError> = Result.failure(StorageError.unexistentKey)
    
    func save<ValueType>(value: ValueType, serializer: (ValueType) -> Any, for key: String) {
        fakedLoadResponse = .success(serializer(value))
    }
        
    func load<ValueType>(key: String, deserializer: (Any) -> ValueType) -> Result<ValueType, StorageError> {
        return fakedLoadResponse.map(deserializer)
    }

}
