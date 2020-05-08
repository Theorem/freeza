//
//  TabBarViewModel.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

public enum TabBarItem: CaseIterable {
    case favorite
    case home
    case settings
    
    var title: String {
        switch self {
        case .favorite:
            return "Favorite"
        case .home:
            return "Top"
        case .settings:
            return "Settings"
        }
    }
    
    var asset: Asset {
        // TODO
        switch self {
        case .settings:
            return .gear
        case .home:
            return .home
        case .favorite:
            return .favorite
        }
    }
}

final class TabBarViewModel {
    
    let items: [TabBarItem] = TabBarItem.allCases
    
    fileprivate (set) var topEntriesViewModel: TopEntriesViewModel!
    
    fileprivate (set) var favoriteEntriesViewModel: FavoriteEntriesViewModel!
    
    fileprivate let _favoriteService: FavoriteEntriesServiceProtocol
    
    init(favoriteService: FavoriteEntriesServiceProtocol) {
        _favoriteService = favoriteService
        self.favoriteEntriesViewModel = FavoriteEntriesViewModel(
            favoriteEntriesService: favoriteService,
            onFavoriteUpdated: { [unowned self] entry in
                self.toggleFavorite(entry: entry)
        })
        self.topEntriesViewModel = TopEntriesViewModel(
            withClient: RedditClient(),
            favoriteService: favoriteService,
            onFavoriteUpdated: { [unowned self] entry in
                self.toggleFavorite(entry: entry)
        })
    }
    
    func toggleFavorite(entry: EntryModel) {
        _favoriteService.toggleFavorite(entry: entry)
        self.topEntriesViewModel.reload(entry: EntryViewModel(withModel: entry.updating(isFavorite: !entry.isFavorite)))
        self.favoriteEntriesViewModel.reload()
    }

}
