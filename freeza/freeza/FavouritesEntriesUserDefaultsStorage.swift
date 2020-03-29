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
    private var cachedFavs = [EntryViewModel]()
    
    private init() {
        load { _, _ in}
    }
    
    public static let shared = FavouritesEntriesUserDefaultsStorage()
    
    func load(completion completionHandler: @escaping ([EntryViewModel]?, Error?) -> Void) {
        guard let storage = storage else {
            completionHandler(nil, StorageError.cannotInitDatabase)
            return
        }
        
        self.cachedFavs.removeAll()
        
        if let data = storage.object(forKey: dataKey) as? Data {
            let decoder = JSONDecoder()
            do {
                let loadedEntries = try decoder.decode([EntryViewModel].self, from: data)
                                
                self.cachedFavs.append(contentsOf: loadedEntries)
                
                completionHandler(self.cachedFavs, nil)
                    return
            } catch {
                debugPrint(error)
            }

            storage.removeObject(forKey: dataKey) // restore database format
            completionHandler(nil, StorageError.incorrectDatabaseFormat)
            return
        }
        completionHandler(self.cachedFavs, nil)
    }
    
    private func persist() throws {
        guard let storage = storage else {
            throw StorageError.cannotInitDatabase
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cachedFavs) {
            storage.set(encoded, forKey: dataKey)
            storage.synchronize()
        }
    }
    
    func contains(entry: EntryViewModel) -> Bool {
        let found = cachedFavs.contains(where: { anotherEntry in
            if let a = entry.url?.absoluteString,
                let b = anotherEntry.url?.absoluteString {
                return a.compare(b) == .orderedSame
            }
            return false
        })
        return found
    }
    
    func add(entry: EntryViewModel) throws {
        if !contains(entry: entry) {
            cachedFavs.append(entry)
                        
            do { try persist() }
            catch let error { throw error }
        }
    }
    
    func remove(entry: EntryViewModel) throws {
        var removed = false
        
        cachedFavs = cachedFavs.filter({ anotherEntry in
            if let a = entry.url?.absoluteString,
                let b = anotherEntry.url?.absoluteString {
                
                removed = true
                return a.compare(b) != .orderedSame
            }
            return true
        })
        
        if removed {
            do { try persist() }
            catch let error { throw error }
        }
    }
    
    func removeAll() throws {
        cachedFavs.removeAll()
        
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
