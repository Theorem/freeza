//
//  TabBarViewModel.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

public enum TabBarItem: CaseIterable {
    case home
    case favorite
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
    
    fileprivate (set) var settingsViewModel: SettingsViewModel!
    
    fileprivate let _favoriteService: FavoriteEntriesServiceProtocol
    
    var defaultTab: TabBarItem {
        return .home
    }
    
    init(favoriteService: FavoriteEntriesServiceProtocol, settings: Settings) {
        _favoriteService = favoriteService
        settingsViewModel = SettingsViewModel(
            settings: Settings(storage: UserDefaults.standard),
            onSettingsChanged: { [unowned self] in
                self.reloadTables()
        })
        self.favoriteEntriesViewModel = FavoriteEntriesViewModel(
            favoriteEntriesService: favoriteService,
            onFavoriteUpdated: { [unowned self] entry in
                self.toggleFavorite(entry: entry)
            },
            settings: settings
        )
        self.topEntriesViewModel = TopEntriesViewModel(
            withClient: RedditClient(),
            favoriteService: favoriteService,
            onFavoriteUpdated: { [unowned self] entry in
                self.toggleFavorite(entry: entry)
            },
            settings: settings
        )
    }
    
    func toggleFavorite(entry: EntryModel) {
        _favoriteService.toggleFavorite(entry: entry)
        self.topEntriesViewModel.changeFavorite(entry: EntryViewModel(withModel: entry.updating(isFavorite: !entry.isFavorite)))
        reloadTables()
    }
    
    func reloadTables() {
        self.topEntriesViewModel.reload()
        self.favoriteEntriesViewModel.reload()
    }

}
