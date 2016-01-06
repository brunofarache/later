import XCTest

extension XCTestCase {

	func expect(description: String!) -> XCTestExpectation {
		return expectationWithDescription(description)
	}

	func fail(error: NSError?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func wait(timeout: Double? = 1 , assert: (() -> ())? = nil) {
		waitForExpectationsWithTimeout(timeout!) { error in
			self.fail(error)
			assert?()
		}
	}

}