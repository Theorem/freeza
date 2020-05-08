//
//  TabBarController.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

// Taken from https://stackoverflow.com/questions/57095330/ios-13-large-navigation-bar-appearance-tabbar-images
extension UINavigationBar {
    
    class func setupAppearance() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = Palette.lightGrey.color
            appearance.titleTextAttributes = textAttributes
            appearance.largeTitleTextAttributes = textAttributes

            self.appearance().standardAppearance = appearance
            self.appearance().compactAppearance = appearance
            self.appearance().scrollEdgeAppearance = appearance
            self.appearance().tintColor = .black
            self.appearance().prefersLargeTitles = true
        } else {
            self.appearance().isTranslucent = false
            self.appearance().barTintColor = .darkGray
            self.appearance().tintColor = .black
            self.appearance().barStyle = .black

            self.appearance().titleTextAttributes = textAttributes
            if #available(iOS 11.0, *) {
                self.appearance().largeTitleTextAttributes = textAttributes
                self.appearance().prefersLargeTitles = true
            }
        }
    }
}

final class TabBarController: UIViewController {
    
    fileprivate let _viewModel: TabBarViewModel
    
    fileprivate let _view: TabBarView
    
    fileprivate let _tabBarControllers: [UINavigationController]
    
    init(viewModel: TabBarViewModel) {
        _viewModel = viewModel
        _view = TabBarView(items: viewModel.items)
        _tabBarControllers = createTabBarControllers(viewModel: viewModel)
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
        setStyle()
        display(item: _viewModel.defaultTab)
        bindViewModel()
    }
    
}

fileprivate extension TabBarController {
    
    func setStyle() {
        UINavigationBar.setupAppearance()
    }
    
    func bindViewModel() {
        _view.tabBar.delegate = self
    }
    
    func display(item: TabBarItem) {
        // This is hacky, but it's basically for showing the tabbar
        // initial tab selected color. selectedItem doesn't trigger the
        // delegate didSelect
        let index = _viewModel.items.firstIndex(of: item)!
        _view.tabBar.selectedItem = _view.tabBar.items?[index]
        
        _tabBarControllers.forEach {
            self.remove($0)
        }

        self.load(
            viewController: _tabBarControllers[index],
            intoView: _view.contentView
        )
        
        guard let controller = _tabBarControllers[index].childViewControllers[safe: 0] else {
            return
        }
        
        controller.navigationItem.title = item.title
    }
}

extension TabBarController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let itemIndex = tabBar.indexForItem(item) else {
            // TODO: This shouldn't happen. In the future, we should track
            // or something similar
            return
        }
        self.display(item: _viewModel.items[itemIndex])
    }
    
}

private func createTabBarControllers(viewModel: TabBarViewModel) -> [UINavigationController] {
    return viewModel.items.map { item in
        switch item {
        case .home:
            return createTopViewController(viewModel: viewModel.topEntriesViewModel)
        case .favorite:
            return createTopViewController(viewModel: viewModel.favoriteEntriesViewModel)
            
        case .settings:
            let settingsViewModel: SettingsViewModel = viewModel.settingsViewModel
            let navigationController = UINavigationController(rootViewController: SettingsViewController(viewModel: settingsViewModel))
            return navigationController
        }
    }
}

func createTopViewController(viewModel: EntriesProvider) -> UINavigationController {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
    let topEntries = navigationController.childViewControllers.first as! EntriesViewController
    topEntries.viewModel = viewModel
    return navigationController
}

