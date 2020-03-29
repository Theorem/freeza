//
//  FavouritesEntriesViewModelTests.swift
//  freezaTests
//
//  Created by Kimi on 29/03/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import XCTest
@testable import freeza

class FavouritesEntriesViewModelTests: XCTestCase {

    func testPersistAndRetrieve() {
                
        let storage: FavouritesEntriesStorageProtocol = FavouritesEntriesUserDefaultsStorage.shared
        
        let favsEntriesViewModel = FavouritesEntriesViewModel(with: storage)
        
        let waitExpectation = expectation(description: "Wait for loadEntries to complete.")
        
        // create test object
        let title = "Example title"
        let author =  "Kimi"
        let created = 1585495117.0
        let thumbnail = "https://b.thumbs.redditmedia.com/51zP35ymRMQUzLl-faW8zv-51qeMj359nWjQcub5MRU.jpg"
        let numComments = 999
        let url = "https://preview.redd.it/lal8n9oeeip41.jpg?auto=webp&amp;s=82020c9540ec227e7278987790f7b49c314903b4"
        
        let dictionary: [String:AnyObject] = [
            "title": title as AnyObject,
            "author": author as AnyObject,
            "created_utc": created as AnyObject,
            "thumbnail": thumbnail as AnyObject,
            "num_comments": numComments as AnyObject,
            "url": url as AnyObject
        ]
        
        // create test entry
        let entryModel = EntryModel(withDictionary: dictionary)
        let testEntry = EntryViewModel(withModel: entryModel)
        
        // empty storage
        try? storage.removeAll()
        
        do {
            // persist test list
            try storage.add(entry: testEntry)
        } catch let error {
            XCTFail("Cannot persist entries. \(error.localizedDescription)")
        }
        
        favsEntriesViewModel.loadEntries {
            
            XCTAssertFalse(favsEntriesViewModel.hasError)
            XCTAssertEqual(favsEntriesViewModel.entries.count, 1)
            if let first = favsEntriesViewModel.entries.first {
                XCTAssertEqual(first.title, title)
                XCTAssertEqual(first.author, author)
            } else {
                XCTFail("Cannot retrieve first entry")
            }
           
            waitExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    
}
