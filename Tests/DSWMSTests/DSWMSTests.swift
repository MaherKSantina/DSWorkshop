import XCTest
@testable import DSWMS

final class DSWMSTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DSWMS().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
