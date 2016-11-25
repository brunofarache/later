import Foundation

public typealias PromiseClosure = (_ fulfill: @escaping (Any) -> Void, _ reject: @escaping (NSError) -> Void) -> Void

public class Promise<T> {

	var operations = [Operation]()

	var promise: ((_ fulfill: @escaping (Any) -> Void, _ reject: @escaping (NSError) -> Void) -> Void)?

	public init(_ block: @escaping () -> (T)) {
		addDependency(operation: BlockOperation { input in
			return block()
		})
	}

	public init(promise: @escaping (_ fulfill: @escaping (T) -> Void, _ reject: @escaping (NSError) -> Void) -> Void) {
		self.promise = {  fulfill, reject in
			promise({ fulfill($0) }, reject)
		}

		addDependency(operation: PromiseOperation(promise: self.promise!))
	}

	init(_ operations: [Operation]) {
		self.operations = operations
	}

	public func done(block: ((T?, NSError?) -> ())? = nil) {
		let queue = OperationQueue()

		for operation in operations {
			operation.catchError = getCatchError(queue: queue, block: block)
		}

		if let done = block {
			addDependency(operation: BlockOperation({ input in
				DispatchQueue.main.async {
					done(input as! T?, nil)
				}
			}))
		}

		queue.addOperations(operations, waitUntilFinished: false)
	}

	public func then<U: Any>(block: @escaping (T) -> (U)) -> Promise<U> {
		addDependency(operation: BlockOperation { input in
			return block(input as! T) as U
		})

		return Promise<U>(self.operations)
	}

	public func then<U: Any>(block: @escaping (T) -> (U, NSError?)) -> Promise<U> {
		addDependency(operation: BlockTupleOperation { input in
			let output = block(input as! T)
			return (output.0, output.1)
		})

		return Promise<U>(self.operations)
	}

	public func then<U: Any>(block: @escaping (T) -> (Promise<U>)) -> Promise<U> {
		addDependency(operation: PromiseOperation(block: { input in
			return block(input as! T).promise!
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
			queue: OperationQueue, block: ((T?, NSError?) -> ())?)
		-> ((NSError) -> ()) {

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
