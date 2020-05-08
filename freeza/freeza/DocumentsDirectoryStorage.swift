//
//  DocumentsDirectory+Storage.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

class DocumentsDirectoryStorage: Storage {
    
    fileprivate let _documentsDirectoryPath: URL
    
    init() {
        _documentsDirectoryPath = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    func load<ValueType>(key: String, deserializer: (Any) -> ValueType) -> Result<ValueType, StorageError> {
        let path = directory(forKey: key)
        
        do {
            let data = try Data(contentsOf: path)
            let dictionary = try JSONSerialization.jsonObject(with: data)
            return .success(deserializer(dictionary))
        } catch {
            print(error)
            return .failure(.incorrectType)
        }
    }
    
    func save<ValueType>(value: ValueType, serializer: (ValueType) -> Any, for key: String) {
        do {
            try JSONSerialization
                    .data(withJSONObject: value)
                    .write(to: directory(forKey: key))
        } catch {
            print(error)
        }
    }
    
    fileprivate func directory(forKey key: String) -> URL {
        return _documentsDirectoryPath.appendingPathComponent("\(key).json")
    }

}
