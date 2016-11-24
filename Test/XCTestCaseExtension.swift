import XCTest

extension XCTestCase {

	func expect(description: String!) -> XCTestExpectation {
		return expectation(description: description)
	}

	func fail(error: Error?) {
		if (error == nil) {
			return
		}

		XCTFail(error!.localizedDescription)
	}

	func wait(timeout: Double? = 1 , assert: (() -> ())? = nil) {
		waitForExpectations(timeout: timeout!) { error in
			self.fail(error: error)
			assert?()
		}
	}

}
