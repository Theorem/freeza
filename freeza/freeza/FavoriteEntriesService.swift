//
//  FavoriteEntriesService.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

protocol FavoriteEntriesServiceProtocol {
    
    func toggleFavorite(entry: EntryModel)
    
    func getFavoriteEntries() -> Result<[EntryModel], StorageError>
    
    func isFavorite(entryUrl: String?) -> Bool
}

class FavoriteEntriesService: FavoriteEntriesServiceProtocol {
    
    enum Keys: String {
        case favorite
    }
    
    fileprivate let _storage: Storage
    
    init(storage: Storage) {
        _storage = storage
    }
    
    func getFavoriteEntries() -> Result<[EntryModel], StorageError> {
        return _storage.load(key: Keys.favorite) { (rawJson: Any) -> [EntryModel] in
            guard let dictionary = rawJson as? [String: [String: AnyObject]] else {
                return []
            }
            
            return dictionary.map { _, value in
                EntryModel(withDictionary: value, isFavorite: true)
            }.sorted(by: { lhs, rhs in
                guard let lhsCreationDate = lhs.creation, let rhsCreationDate = rhs.creation else {
                    return true
                }
                return lhsCreationDate > rhsCreationDate
            })
        }
    }
    
    func isFavorite(entryUrl: String?) -> Bool {
        let loadedIsFavorite = try? _storage.load(key: Keys.favorite) { (rawJson: Any) -> Bool in
            guard
                let entryURL = entryUrl,
                let dictionary = rawJson as? [String: [String: AnyObject]] else {
                return false
            }
            
            return dictionary.keys.contains(entryURL)
        }.get()
        
        return loadedIsFavorite ?? false
    }
    
    func toggleFavorite(entry: EntryModel) {
        let favoriteEntries = (try? getFavoriteEntries().get()) ?? []
        var favoriteDictionary = toDictionary(entries: favoriteEntries)
    
        guard let entryURL = entry.url else {
            // TODO
            return
        }
        
        let newIsFavorite = !entry.isFavorite
        
        switch newIsFavorite {
        case false:
            favoriteDictionary[entryURL.absoluteString] = nil
        case true:
            favoriteDictionary[entryURL.absoluteString] = entry.asDictionary
        }
        
        _storage.save(
            value: favoriteDictionary,
            serializer: { favoriteDictionary in favoriteDictionary },
            for: Keys.favorite
        )
    }
    
}

private func toDictionary(entries: [EntryModel]) -> [String: [String: AnyObject]] {
    var dictionary: [String: [String: AnyObject]] = [:]
    
    entries.forEach { entry in
        if let url = entry.url {
            dictionary[url.absoluteString] = entry.asDictionary
        }
    }
    
    return dictionary
}

