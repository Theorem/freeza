import XCTest
@testable import freeza

class TopEntriesViewModelTests: XCTestCase {

    func testCompletion() {
        
        let client = RedditClient()
        let topEntriesViewModel = TopEntriesViewModel(withClient: client, favoriteService: FavoriteEntriesService(storage: FakeStorage()), onFavoriteUpdated: { _ in })
        
        let waitExpectation = expectation(description: "Wait for loadEntries to complete.")
        
        topEntriesViewModel.loadEntries {
            
            XCTAssertEqual(topEntriesViewModel.entries.count, 50)
            XCTAssertNil(topEntriesViewModel.errorMessage)
            
            topEntriesViewModel.entries.forEach { entryViewModel in
                
                XCTAssertFalse(entryViewModel.hasError)
            }
            
            waitExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testError() {
        let client = TestErrorClient()
        let topEntriesViewModel = TopEntriesViewModel(withClient: client, favoriteService: FavoriteEntriesService(storage: FakeStorage()), onFavoriteUpdated: { _ in })
        
        let waitExpectation = expectation(description: "Wait for loadEntries to complete.")
        
        topEntriesViewModel.loadEntries {
            
            XCTAssertNotNil(topEntriesViewModel.errorMessage)
            XCTAssertEqual(topEntriesViewModel.errorMessage, TestErrorClient.testErrorMessage)
            waitExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
}

class TestErrorClient: Client {
    
    static let testErrorMessage = "TEST_ERROR"

    func fetchTop(after afterTag: String?, completionHandler: @escaping ([String : AnyObject]) -> (), errorHandler: @escaping (String) -> ()) {
        
        errorHandler(TestErrorClient.testErrorMessage)
    }
}
