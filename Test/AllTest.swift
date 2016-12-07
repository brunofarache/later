import XCTest
import later

class AllTest : XCTestCase {

	func testAll() {
		let expectation = expect(description: "testAll")
		var output = [String?]()

		let p = Promise {
			return "one"
		}
		.all(
			{ value -> String in
				XCTAssertEqual("one", value)
				return "two"
			},
			{ value in
				XCTAssertEqual("one", value)
				return "three"
			}
		)

		p.done { value, error in
			output = value!
			XCTAssertNil(error)
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("two", output.first!)
			XCTAssertEqual("three", output.last!)
		}
	}

}
