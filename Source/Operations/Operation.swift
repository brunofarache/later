import Foundation

class Operation : Foundation.Operation {

	var catchError: ((Error) -> ())?
	var output: Any?

}
