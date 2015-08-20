import Kiwi
import Nimble

final class KWSwiftNimbleTests: KWSpec {
    override class func buildExampleGroups() {
        describe("Nimble matchers") {
            it("supports expect()") {
                expect(1 + 1).to(equal(2))
            }
        }
    }
}
