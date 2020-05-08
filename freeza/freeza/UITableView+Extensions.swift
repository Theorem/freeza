//
//  UITableView+Extensions.swift
//  freeza
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueReusableCell<CellType: UITableViewCell>(cellClass: CellType.Type, for indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as! CellType
    }
}
