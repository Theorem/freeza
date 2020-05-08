//
//  Palette.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

enum Palette {
    case red
    case white
    case lightGrey
    case darkTableBackground
    case tableSeparator
    
    var color: UIColor {
        switch self {
        case .red:
            return UIColor(rgb: 0xFF6769)
        case .white:
            return UIColor(rgb: 0xFFFEFF)
        case .lightGrey:
            return UIColor(rgb: 0xF6F5F5)
        case .darkTableBackground:
            return UIColor(rgb: 0xE7E7ED)
        case .tableSeparator:
            return UIColor(rgb: 0xDCDCE1)
        }
    }
}
