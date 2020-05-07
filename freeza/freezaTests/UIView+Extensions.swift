//
//  UIView+Extensions.swift
//  freezaTests
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

extension UIView {

    func findViews<View: UIView>(subclassOf: View.Type) -> [View] {
        return recursiveSubviews.find(elementsOfType: subclassOf)
    }
    
    func findView<View: UIView>(subclassOf: View.Type) -> View? {
        let allViews = findViews(subclassOf: subclassOf)
        assert(allViews.count <= 1, "Found more than one view of type \(subclassOf)")
        return allViews.first
    }
    
    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }

}
