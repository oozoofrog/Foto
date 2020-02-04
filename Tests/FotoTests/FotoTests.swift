import XCTest
import Photos
@testable import Foto

final class FotoTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertFalse(Foto().isAuthorized)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
