import Foundation

class Operation : Foundation.Operation {

	var catchError: ((NSError) -> ())?
	var output: Any?

}
