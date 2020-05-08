//
//  EntryModel+Faked.swift
//  freezaTests
//
//  Created by Francisco Depascuali on 08/05/2020.
//  Copyright © 2020 Zerously. All rights reserved.
//

import Foundation
@testable import freeza

extension EntryModel {
    
    static func faked(
        title: String? = "title",
        author: String? = "author",
        creation: Date? = Date(),
        thumbnailURL: URL? = URL(string: "fakethumbnailURLurl"),
        commentsCount: Int? = 0,
        url: URL? = URL(string: "fakeurl"),
        isFavorite: Bool = false) -> EntryModel {
        return self.init(title: title, author: author, creation: creation, thumbnailURL: thumbnailURL, commentsCount: commentsCount, url: url, isFavorite: isFavorite)
    }
    
}
