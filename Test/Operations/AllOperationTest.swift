import XCTest
@testable import later

class AllOperationTest : XCTestCase {

	func testFirst_Long() {
		let expectation = expect(description: "testFirst_Long")
		let queue = OperationQueue()

		let operation = AllOperation([
			{ value in
				sleep(1)
				expectation.fulfill()
				return "one"
			},
			{ value in
				return "two"
			}]
		)

		queue.addOperation(operation)

		wait(timeout: 2) {
			let output = operation.output as! [Any?]
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first! as? String)
			XCTAssertEqual("two", output.last! as? String)
		}
	}

}
