import XCTest
@testable import EmotionClassification

final class EmotionClassificationTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EmotionClassification().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
