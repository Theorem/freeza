//
//  TabBarTests.swift
//  freezaTests
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import XCTest
@testable import freeza

extension UITabBar {
    
    func select(item: TabBarItem) {
        guard
            let index = TabBarItem.allCases.index(of: item),
            let tabBarItems = self.items else { return }
        self.delegate?.tabBar?(self, didSelect: tabBarItems[index])
    }
    
}

class TabBarTests: XCTestCase {

    func isSelected(tabBar: UITabBar, item: TabBarItem) -> Bool {
        guard let selectedItem = tabBar.selectedItem else {
            return false
        }
        return tabBar.items?.firstIndex(of: selectedItem) == TabBarItem.allCases.index(of: item)
    }
    
    func testSelectItem() throws {
        let controller = TabBarController(viewModel: TabBarViewModel())
        let maybeTabBar = controller.view.findView(subclassOf: UITabBar.self)
        let tabBar: UITabBar = try XCTUnwrap(maybeTabBar)
        
        // By default home is selected
        XCTAssertTrue(isSelected(tabBar: tabBar, item: .home))
        XCTAssertEqual(controller.childViewControllers.count, 1)
        
        // This is because it's a UINavigationController
        XCTAssertTrue(controller.childViewControllers.first?.childViewControllers.first is TopEntriesViewController)
        
        
        tabBar.select(item: .favorite)
        XCTAssertTrue(isSelected(tabBar: tabBar, item: .favorite))
        XCTAssertEqual(controller.childViewControllers.count, 1)
        // TODO: Change this when adding favorite screens
        XCTAssertTrue(controller.childViewControllers.first is UIViewController)
        
        tabBar.select(item: .settings)
        XCTAssertTrue(isSelected(tabBar: tabBar, item: .settings))
        XCTAssertEqual(controller.childViewControllers.count, 1)
        // TODO: Change this when adding settings screen
        XCTAssertTrue(controller.childViewControllers.first is UIViewController)
    }
}
