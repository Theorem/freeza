//
//  TabBarViewModel.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

enum TabBarItem: CaseIterable {
    case favorite
    case home
    case settings
    
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
    
    let selectedItem: TabBarItem = .home
    
}
