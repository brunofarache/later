import Foundation

public typealias PromiseClosure<T> = (_ fulfill: @escaping (T) -> Void, _ reject: @escaping (Error) -> Void) -> Void

public class Promise<T> {

	var operations = [Operation]()

	var promise: (PromiseClosure<T>)?

	public init(_ block: @escaping () -> (T)) {
		addDependency(operation: BlockOperation<(), T> { input in
			return block()
		})
	}

	public init(promise: @escaping PromiseClosure<T> ) {
		self.promise = promise

		addDependency(operation: PromiseOperation<(), T>(promise: self.promise!))
	}

	init(_ operations: [Operation]) {
		self.operations = operations
	}

	public func done(block: ((T?, Error?) -> ())? = nil) {
		let queue = OperationQueue()

		for operation in operations {
			operation.catchError = getCatchError(queue: queue, block: block)
		}

		if let done = block {
			addDependency(operation: BlockOperation({ input in
				DispatchQueue.main.async {
					done(input, nil)
				}
			}))
		}

		queue.addOperations(operations, waitUntilFinished: false)
	}

	public func then<U>(block: @escaping (T) -> (U)) -> Promise<U> {
		addDependency(operation: BlockOperation { input in
			return block(input!)
		})

		return Promise<U>(self.operations)
	}

	public func then<U>(block: @escaping (T) -> (U, Error?)) -> Promise<U> {
		addDependency(operation: BlockTupleOperation<T,U> { input in
			let output = block(input!)
			return (output.0, output.1)
		})

		return Promise<U>(self.operations)
	}

	public func then<U>(block: @escaping (T) -> (Promise<U>)) -> Promise<U> {
		addDependency(operation: PromiseOperation(concatPromise: { input in
			block(input!)
		}))

		return Promise<U>(self.operations)
	}

	func addDependency(operation: Operation) {
		if let last = operations.last {
			operation.addDependency(last)
		}

		operations.append(operation)
	}

	func getCatchError(
			queue: OperationQueue, block: ((T?, Error?) -> ())?)
		-> ((Error) -> ()) {

		return { error in
			queue.cancelAllOperations()

			if let done = block {
				DispatchQueue.main.async {
					done(nil, error)
				}
			}
		}
	}

}
