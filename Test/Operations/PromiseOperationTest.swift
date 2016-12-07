import XCTest
@testable import later

class PromiseOperationTest : XCTestCase {

	func testFulfill() {
		let expectation = expect(description: "testFulfill")
		let queue = OperationQueue()

		let operation = PromiseOperation<Void, String> { fulfill, reject in
			fulfill("one")
			expectation.fulfill()
		}

		operation.catchError = { error in
			XCTFail("Reject shouldn't be called")
		}

		queue.addOperation(operation)

		wait {
			XCTAssertEqual("one", operation.output)
		}
	}

	func testReject() {
		let expectation = expect(description: "testReject")
		let queue = OperationQueue()
		var error: NSError?

		let operation = PromiseOperation<Void, Void> { fulfill, reject in
			reject(NSError(domain: "domain", code: 1, userInfo: nil))
		}

		operation.catchError = {
			error = $0 as NSError
			expectation.fulfill()
		}

		queue.addOperation(operation)

		wait {
			XCTAssertEqual("domain", error!.domain)
			XCTAssertEqual(1, error!.code)
		}
	}

}
