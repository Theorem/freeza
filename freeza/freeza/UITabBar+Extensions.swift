//
//  UITabBar+Extensions.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

extension UITabBar {
    
    func indexForItem(_ item: UITabBarItem) -> Int? {
        return items?
            .enumerated()
            .first(where: { _, tabBarItem -> Bool in
                tabBarItem == item
            })
            .map { index, _ in index }
    }
}
