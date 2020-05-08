//
//  FavoriteEntriesViewModel.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

class FavoriteEntriesViewModel: EntriesProvider {
    
    var shouldShowMore: Bool {
        return false
    }

    let _favoriteEntriesService: FavoriteEntriesServiceProtocol
    
    let _onFavoriteUpdated: (EntryModel) -> ()
    
    var onEntriesUpdated: () -> () = { }
    
    init(favoriteEntriesService: FavoriteEntriesServiceProtocol,
         onFavoriteUpdated: @escaping (EntryModel) -> ()) {
        _favoriteEntriesService = favoriteEntriesService
        _onFavoriteUpdated = onFavoriteUpdated
    }
    
    var entries: [EntryViewModel] {
        let favoriteEntries = try? _favoriteEntriesService.getFavoriteEntries().get()
        
        return (favoriteEntries ?? []).map(EntryViewModel.init)
    }
    
    func loadEntries(withCompletion completionHandler: @escaping () -> ()) {
        completionHandler()
    }
    
    var errorMessage: String? {
        switch _favoriteEntriesService.getFavoriteEntries() {
        case .failure:
            return "Ups! Ha ocurrido un error"
        case .success:
            return nil
        }
    }
    
    func reload() {
        onEntriesUpdated()
    }
    
    func toggleFavorite(entry: EntryViewModel) {
        _onFavoriteUpdated(entry.model)
    }
    
}
