//
//  Asset.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

enum Asset: String, CaseIterable {
    case gear
    case favorite
    case home
    case heart_empty
    case heart_fill
    
    public var image: UIImage {
        guard let fetchedImage = UIImage(asset: self) else {
            assertionFailure("Couldn´t find image \(self), did you add it to Assets/xcassets?")
            return UIImage()
        }
        
        return fetchedImage
    }
}

extension UIImage {
    
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
    
}

