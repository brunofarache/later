import XCTest
import later

class ThenTest : XCTestCase {

	func testReturns_Array_Then_Empty() {
		let expectation = expect(description: "testReturns_Array_Then_Empty")

		let p = Promise {
			return "one"
		}
		.then {
			return [$0, "two"]
		}
		.then { value -> () in
			XCTAssertEqual(2, value.count)
			XCTAssertEqual("one", value.first!)
			XCTAssertEqual("two", value.last!)
			expectation.fulfill()
		}

		p.done()
		
		wait()
	}

	func testReturns_Empty_Then_Empty() {
		let expectation = expect(description: "testReturns_Empty_Then_Empty")
		var order = [String]()

		let p = Promise {
			order.append("one")
		}
		.then {
			order.append("two")
		}
		.then { () -> () in
			order.append("three")
			expectation.fulfill()
		}

		p.done()

		wait {
			XCTAssertEqual(3, order.count)
			XCTAssertEqual("one", order.first!)
			XCTAssertEqual("two", order[1])
			XCTAssertEqual("three", order.last!)
		}
	}

	func testReturns_Empty_Then_String() {
		let expectation = expect(description: "testReturns_Empty_Then_String")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then {
			output.append($0)
		}
		.then { () -> String in
			return "two"
		}

		p.done { value, error in
			output.append(value!)
			XCTAssertTrue(Thread.isMainThread)
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

	func testReturns_Promise() {
		let expectation = expect(description: "testReturns_Promise")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then { value -> Promise<String> in
			output.append(value)

			return Promise<String>(promise: { fulfill, reject in
				fulfill("two")
			})
		}
		.then { value -> () in
			output.append(value)
			expectation.fulfill()
		}

		p.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

	func testReturns_String_Then_Empty() {
		let expectation = expect(description: "testReturns_String_Then_Empty")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then { value -> String in
			output.append(value)
			return "two"
		}
		.then { value -> () in
			output.append(value)
			expectation.fulfill()
		}

		p.done()

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

	func testReturns_String_Then_String() {
		let expectation = expect(description: "testReturns_String_Then_String")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then { value -> String in
			output.append(value)
			return "two"
		}
		.then { value -> String in
			output.append(value)
			return "three"
		}

		p.done { value, error in
			output.append(value!)
			XCTAssertTrue(Thread.isMainThread)
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual(3, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output[1])
			XCTAssertEqual("three", output.last!)
		}
	}

	func testReturns_Tuple_Then_Empty() {
		let expectation = expect(description: "testReturns_Tuple_Then_Empty")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then { value -> (String, NSError?) in
			output.append(value)
			return ("two", nil)
		}
		.then { value -> () in
			output.append(value)
		}

		p.done { value, error in
			XCTAssertNil(error)
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual(2, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output.last!)
		}
	}

	func testReturns_Tuple_Of_Strings_Then_Empty() {
		let expectation = expect(description: "testReturns_Tuple_Of_Strings_Then_Empty")
		var output = [String]()

		let p = Promise {
			return "one"
		}
		.then { value -> (String, String) in
			output.append(value)
			return ("two", "three")
		}
		.then { value -> () in
			output.append(value.0)
			output.append(value.1)
		}

		p.done { value, error in
			XCTAssertNil(error)
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual(3, output.count)
			XCTAssertEqual("one", output.first!)
			XCTAssertEqual("two", output[1])
			XCTAssertEqual("three", output.last!)
		}
	}

	func testPromise_With_More_Operations() {
		let expectation = expect(description: "test then with promise")

		let promiseWithOperation = Promise {
			return "one"
		}
		.then { _ in
			return "two"
		}

		Promise {
			return "three"
		}
		.then { _ in
			return promiseWithOperation
		}
		.done { result, _ in
			XCTAssertEqual(result, "two")
			expectation.fulfill()
		}

		waitForExpectations(timeout: 10, handler: nil)
	}

}
