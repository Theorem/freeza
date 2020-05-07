//
//  TabBarController.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

final class TabBarController: UIViewController {
    
    fileprivate let _viewModel: TabBarViewModel
    
    fileprivate let _view: TabBarView
    
    let tabBarControllers: [UIViewController]
    
    init(viewModel: TabBarViewModel) {
        _viewModel = viewModel
        _view = TabBarView(items: viewModel.items)
        tabBarControllers = createTabBarControllers(items: viewModel.items)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display(item: .home)
    }
    
}

fileprivate extension TabBarController {
    
    func display(item: TabBarItem) {
        tabBarControllers.forEach {
            $0.removeFromParentViewController()
        }
        
        let index = _viewModel.items.firstIndex(of: item)!
        self.load(
            viewController: tabBarControllers[index],
            intoView: _view.contentView
        )
    }
}

private func createTabBarControllers(items: [TabBarItem]) -> [UIViewController] {
    return items.map { item in
        switch item {
        case .home:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateInitialViewController()!
            
        case .favorite:
            // TODO: Add favorite component
            return UIViewController()
            
        case .settings:
            // TODO: Add settings component
            return UIViewController()
        }
    }
}
