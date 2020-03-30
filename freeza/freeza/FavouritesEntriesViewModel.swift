//
//  FavouritesEntriesViewModel.swift
//  freeza
//
//  Created by Kimi on 29/03/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

class FavouritesEntriesViewModel {

    var hasError = false
    var errorMessage: String? = nil

    var allEntries = [EntryViewModel]()
    var safeEntries: [EntryViewModel] {
        get {
            allEntries.filter({ entry in
                return !entry.hasExplicitContent
            })
        }
    }
    
    private let storage: FavouritesEntriesStorageProtocol!
    
    init(with storage: FavouritesEntriesStorageProtocol) {
        self.storage = storage
    }
    
    func loadEntries(withCompletion completionHandler: @escaping () -> ()) {
        storage.load { entries, error in
            guard let entries = entries else {
                if let error = error {
                    debugPrint("Error loading entries. \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                } else {
                    self.errorMessage = "unknown error"
                }
                
                self.hasError = true
                self.allEntries.removeAll()                    
                completionHandler()
                return
            }
            self.allEntries = entries
            self.hasError = false
            self.errorMessage = nil
            completionHandler()
        }
    }
}
