//
//  Array+Extensions.swift
//  freeza
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation

extension Array {
    
    func find<T>(elementsOfType: T.Type) -> [T] {
        return self.compactMap { $0 as? T }
    }
    
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
    
}
