import XCTest
import Photos
@testable import Foto

final class FotoTests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    func testSort() {
        let date = Date() as NSDate
        let op = Option
            .sort(by: .creationDate)
            .sort(by: .modificationDate, ascending: false)
            .fetchLimit(20)
            .predicate(left: \.creationDate, operator: .lessThan, to: date)
            .predicate(left: \.creationDate, operator: .greaterThanOrEqualTo, to: date)
            .predicate(logical: .or, left: \.creationDate, operator: .equalTo, to: date)
            .fetchOptions
        XCTAssertEqual(op.sortDescriptors,
                       [NSSortDescriptor(key: "creationDate", ascending: true), NSSortDescriptor(key: "modificationDate", ascending: false)])
        XCTAssertEqual(op.fetchLimit, 20)
        XCTAssertEqual(op.predicate, NSPredicate(format: "(creationDate < %@ AND creationDate >= %@) OR creationDate == %@", date, date, date))
    }

    static var allTests = [
        ("testSort", testSort),
    ]
}

