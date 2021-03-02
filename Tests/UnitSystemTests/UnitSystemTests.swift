import XCTest
@testable import UnitSystem

final class UnitSystemTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UnitSystem().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
