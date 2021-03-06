import XCTest
import later

class CatchTest : XCTestCase {

	func testBlock_Returns_Error() {
		let expectation = expect(description: "testBlock_Returns_Error")
		var e: NSError?

		let p = Promise {
			return "one"
		}
		.then { value -> (String, Error?) in
			return (value, self._createError())
		}

		p.done { value, error in
			e = error as? NSError
			XCTAssertNil(value)
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual("domain", e!.domain)
			XCTAssertEqual(1, e!.code)
		}
	}

	func testPromise_Returns_Error() {
		let expectation = expect(description: "testPromise_Returns_Error")
		var e: NSError?

		let p = Promise<()>(promise: { fulfill, reject in
			reject(self._createError())
		})

		p.done { value, error in
			e = error as? NSError
			expectation.fulfill()
		}

		wait {
			XCTAssertEqual("domain", e!.domain)
			XCTAssertEqual(1, e!.code)
		}
	}

	func testError_Fall_Through() {
		let expectation = expect(description: "testError_Fall_Through")
		var e: NSError?

		let p = Promise<()>(promise: { fulfill, reject in
			DispatchQueue.global().async {
				sleep(1)
				reject(self._createError())
			}
		})
		.then {
			XCTFail(
				"Then shouldn't be called, should be skipped directly to catch")
		}

		p.done { value, error in
			e = error as? NSError
			expectation.fulfill()
		}

		wait(timeout: 1.5) {
			XCTAssertEqual("domain", e!.domain)
			XCTAssertEqual(1, e!.code)
		}
	}

	private func _createError() -> NSError {
		return NSError(domain: "domain", code: 1, userInfo: nil)
	}

	

}
