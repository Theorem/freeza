//
//  FavouritesEntriesUserDefaultsStorage.swift
//  freeza
//
//  Created by Kimi on 29/03/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit



class FavouritesEntriesUserDefaultsStorage: FavouritesEntriesStorageProtocol {
    
    private let storage = UserDefaults(suiteName: "favourites_storage")
    private let dataKey = "data"
    
    private init() {}
    
    public static let shared = FavouritesEntriesUserDefaultsStorage()
    
    func load(completion completionHandler: @escaping ([EntryViewModel]?, Error?) -> Void) {
        guard let storage = storage else {
            completionHandler(nil, StorageError.cannotInitDatabase)
            return
        }
        
        if let data = storage.object(forKey: dataKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedEntries = try? decoder.decode([EntryViewModel].self, from: data) {
                completionHandler(loadedEntries, nil)
            } else {
                storage.removeObject(forKey: dataKey) // restore database format
                completionHandler(nil, StorageError.incorrectDatabaseFormat)
            }
            return
        }
        completionHandler([EntryViewModel](), nil)
    }
    
    func persist(list: [EntryViewModel]) throws {
        guard let storage = storage else {
            throw StorageError.cannotInitDatabase
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            storage.set(encoded, forKey: dataKey)
        }
    }
    
    func removeAll() throws {
        guard let storage = storage else {
            throw StorageError.cannotInitDatabase
        }
        storage.removeObject(forKey: dataKey)
    }
    

    enum StorageError: Error {
        case cannotInitDatabase
        case incorrectDatabaseFormat
    }
}
