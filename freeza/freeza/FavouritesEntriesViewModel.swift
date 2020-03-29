//
//  FavouritesEntriesViewModel.swift
//  freeza
//
//  Created by Kimi on 29/03/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import UIKit

class FavouritesEntriesViewModel {

    var entries = [EntryViewModel]()
    var hasError = false
    var errorMessage: String? = nil

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
                self.entries.removeAll()                    
                completionHandler()
                return
            }
            self.entries = entries
            self.hasError = false
            self.errorMessage = nil
            completionHandler()
        }
    }
}
