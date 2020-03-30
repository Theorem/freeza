import XCTest
@testable import freeza

class TopEntriesViewModelTests: XCTestCase {

    func testCompletion() {
        
        let client = RedditClient()
        let topEntriesViewModel = TopEntriesViewModel(withClient: client)
        
        let waitExpectation = expectation(description: "Wait for loadEntries to complete.")
        
        topEntriesViewModel.loadEntries {
            
            XCTAssertEqual(topEntriesViewModel.allEntries.count, 50)
            XCTAssertFalse(topEntriesViewModel.hasError)
            
            topEntriesViewModel.allEntries.forEach { entryViewModel in
                
                XCTAssertFalse(entryViewModel.hasError)
            }
            
            waitExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testError() {
        
        let client = TestErrorClient()
        let topEntriesViewModel = TopEntriesViewModel(withClient: client)
        
        let waitExpectation = expectation(description: "Wait for loadEntries to complete.")
        
        topEntriesViewModel.loadEntries {
            
            XCTAssertTrue(topEntriesViewModel.hasError)
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
