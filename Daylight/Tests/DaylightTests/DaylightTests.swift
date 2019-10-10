import XCTest
@testable import Daylight

final class DaylightTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Daylight().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
