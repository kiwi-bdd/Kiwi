import Kiwi
import XCTest

final class SwiftXCTestAssertionTests: KWSpec {
    override class func buildExampleGroups() {
        describe("XCTest assertions in Swift") {
            it("supports XCTAssert()") {
                XCTAssert(1 + 1 == 2)
            }
        }
    }
}
