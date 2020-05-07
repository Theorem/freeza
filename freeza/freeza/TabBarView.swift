//
//  TabBarView.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

final class TabBarView: UIView {
    
    let contentView: UIView = prepareContentView()
    
    let tabBar: UITabBar
    
    init(items: [TabBarItem]) {
        tabBar = prepareTabBar(items: items)
        super.init(frame: .zero)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TabBarView {
    
    func addSubviews() {
        addSubview(contentView)
        addSubview(tabBar)
    }
    
    func setConstraints() {
        [contentView, tabBar].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            tabBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBar.leftAnchor.constraint(equalTo: leftAnchor),
            tabBar.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
}

private func prepareContentView() -> UIView {
    return UIView()
}

private func prepareTabBar(items: [TabBarItem]) -> UITabBar {
    let tabBar = UITabBar()
    
    tabBar.items = items.map {
        // NOTE: We have to pass the .alwaysOriginal because if not iOS will tint
        // the tabbar with its colors.
        return UITabBarItem(title: nil,
                            image: $0.asset.image,
                            selectedImage: nil)
    }
    
    tabBar.isTranslucent = false
    
    return tabBar
}
