//
//  UIView+Extensions.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

public extension UIView {

    func loadInto(containerView: UIView, insets: UIEdgeInsets = .zero) {
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerView.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -insets.bottom),
            leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: insets.left)
        ])
    }
}
