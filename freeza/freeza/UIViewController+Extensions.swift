//
//  UIViewController+Extensions.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func load(viewController: UIViewController, intoView: UIView? = .none, insets: UIEdgeInsets = .zero) {
        let containerView: UIView = intoView ?? view
        self.addChildViewController(viewController)
        viewController.view.loadInto(containerView: containerView, insets: insets)
        viewController.didMove(toParentViewController: self)
    }

    func remove(_ controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }

}
