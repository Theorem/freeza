//
//  FavoriteEntriesServiceTests.swift
//  freezaTests
//
//  Created by Francisco Depascuali on 07/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

@testable import freeza
import Foundation
import XCTest

class FavoriteEntriesServiceTests: XCTestCase {

    var favoriteEntriesService: FavoriteEntriesService!
    
    var fakeStorage: FakeStorage!
    
    override func setUp() {
        super.setUp()
        fakeStorage = FakeStorage()
        favoriteEntriesService = FavoriteEntriesService(storage: fakeStorage)
    }

    func testGetFavoriteEntries() {
        let fakedFavoriteEntries = [
                    EntryModel.faked(title: "first", url: URL(string: "first")),
                    EntryModel.faked(title: "second", url: URL(string: "second"))
        ]
                
        fakedFavoriteEntries.forEach {
            favoriteEntriesService.toggleFavorite(entry: $0)
        }
        
        let favoriteEntries = favoriteEntriesService.getFavoriteEntries()
        
        // Reversed because we always get favorites sorted by date
        XCTAssertEqual(try? favoriteEntries.get().reversed(), fakedFavoriteEntries)
    }
    
    func testIsFavorite() {
        let fakedFavoriteEntries = [
            EntryModel.faked(title: "first", url: URL(string: "first")),
            EntryModel.faked(title: "second", url: URL(string: "second"))
        ]
        
        let randomEntries = [
            EntryModel.faked(title: "third", url: URL(string: "third")),
            EntryModel.faked(title: "fourth", url: URL(string: "fourth")),
        ]
        
        fakedFavoriteEntries.forEach {
            favoriteEntriesService.toggleFavorite(entry: $0)
        }
        
        let areFavorite = (fakedFavoriteEntries + randomEntries)
            .map { favoriteEntriesService.isFavorite(entryUrl: $0.url!.absoluteString) }
        
        XCTAssertEqual(areFavorite, [true, true, false, false])
    }
    
    func testToggleFavorite() throws {
        let fakedFavoriteEntry = EntryModel.faked(title: "first", url: URL(string: "first"), isFavorite: false)
        
        favoriteEntriesService.toggleFavorite(entry: fakedFavoriteEntry)
        XCTAssertTrue(favoriteEntriesService.isFavorite(entryUrl: fakedFavoriteEntry.url!.absoluteString))
        
        let newEntries = try favoriteEntriesService.getFavoriteEntries().get()
        favoriteEntriesService.toggleFavorite(entry: newEntries[0])
        XCTAssertFalse(favoriteEntriesService.isFavorite(entryUrl: fakedFavoriteEntry.url!.absoluteString))

        favoriteEntriesService.toggleFavorite(entry: fakedFavoriteEntry)
        XCTAssertTrue(favoriteEntriesService.isFavorite(entryUrl: fakedFavoriteEntry.url!.absoluteString))
    }

}
