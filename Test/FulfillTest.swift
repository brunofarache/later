import XCTest

class Fulfill : XCTestCase {

	func testFulfill() {
		let expectation = expect("testFulfill")
		var output = [String]()

		Promise<String>(promise: { fulfill, reject in
			let queue = dispatch_get_global_queue(
				DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

			dispatch_async(queue, {
				fulfill("one")
			})
		})
		.then { value -> String in
			output.append(value)
			return "two"
		}
		.then { value -> String in
			output.append(value)
			expectation.fulfill()
			return "three"
		}
		.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

}