//
//  Array+Extensions.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

extension Array {
    
    func find<T>(elementsOfType: T.Type) -> [T] {
        return self.compactMap { $0 as? T }
    }
    
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
    
}

enum SpacingType {
    case constant(CGFloat)
    case customSpacingAfterView([UIView: CGFloat])
}

extension Array where Element: UIView {
    
    @available(iOS 11.0, *)
    func stacked(
        axis: NSLayoutConstraint.Axis,
        spacing: SpacingType,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: self)
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        
        switch spacing {
        case .constant(let spacing):
            stackView.spacing = spacing
        case .customSpacingAfterView(let viewsAndSpacing):
            viewsAndSpacing.forEach { key, value in
                stackView.setCustomSpacing(value, after: key)
            }
        }
    
        return stackView
    }
    
}
