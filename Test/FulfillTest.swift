import XCTest
import later

class Fulfill : XCTestCase {



	func testFulfill() {
		let expectation = expect(description: "testFulfill")
		var output = [String]()

		Promise<String>(promise: { fulfill, reject in

			fulfill("one")
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
