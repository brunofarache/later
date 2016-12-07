import Foundation

class Operation : Foundation.Operation {

	var catchError: ((Error) -> ())?
}

class OperationWithOutput<T> : Operation {
	var output: T?
}
