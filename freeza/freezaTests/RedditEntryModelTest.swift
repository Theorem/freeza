import XCTest
@testable import freeza

class RedditEntryModelTest: XCTestCase {

    func testInit() {

        let title = "TEST_TITLE"
        let author = "TEST_AUTHOR"
        let creation = NSDate()
        let thumbnailURL = URL(string: "http://mysite.com/thumb.jpg")!
        let commentsCount = 200
        
        let dictionary: [String: AnyObject] = [
            "title": title as AnyObject,
            "author": author as AnyObject,
            "created_utc": creation.timeIntervalSince1970 as AnyObject,
            "thumbnail": thumbnailURL.absoluteString as AnyObject,
            "num_comments": commentsCount as AnyObject
        ]
        
        let entryModel = EntryModel(withDictionary: dictionary, isFavorite: false)
        
        XCTAssertEqual(entryModel.title, title)
        XCTAssertEqual(entryModel.author, author)
        XCTAssertEqual(entryModel.creation?.timeIntervalSince1970, creation.timeIntervalSince1970)
        XCTAssertEqual(entryModel.thumbnailURL, thumbnailURL)
        XCTAssertEqual(entryModel.commentsCount, commentsCount)
    }
    
    func testInitWithNils() {
        
        let dictionary = [String: AnyObject]()
        let entryModel = EntryModel(withDictionary: dictionary, isFavorite: false)
        
        XCTAssertNil(entryModel.title)
        XCTAssertNil(entryModel.author)
        XCTAssertNil(entryModel.creation)
        XCTAssertNil(entryModel.thumbnailURL)
        XCTAssertNil(entryModel.commentsCount)
    }
}
