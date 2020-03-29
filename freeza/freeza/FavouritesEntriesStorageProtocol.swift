//
//  FavouritesEntriesStorageProtocol.swift
//  freeza
//
//  Created by Kimi on 29/03/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

protocol FavouritesEntriesStorageProtocol {
    func load(completion: @escaping ([EntryViewModel]?, Error?) -> Void)
    func contains(entry: EntryViewModel) -> Bool
    func add(entry: EntryViewModel) throws
    func remove(entry: EntryViewModel) throws
    func removeAll() throws
}
