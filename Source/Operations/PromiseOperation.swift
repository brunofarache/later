import Foundation

class PromiseOperation<T,U> : OperationWithOutput<U> {

	var promise: (PromiseClosure<U>)?
	var concatPromise: ((T?) -> Promise<U>)?

	init(promise: @escaping PromiseClosure<U>) {
		self.promise = promise
	}

	init(concatPromise: @escaping (T?) -> Promise<U>) {
		self.concatPromise = concatPromise
	}

	override func main() {
		if let conconcatPromise = concatPromise,
			let operation = dependencies.last as? OperationWithOutput<T> {

			// If we are concatenating a Promise we have to execute all the operations in that
			// promise and pass the output along
			let ops = conconcatPromise(operation.output).operations
			let operationQueue = OperationQueue()

			operationQueue.addOperations(ops, waitUntilFinished: true)

			self.output = (ops.last! as! OperationWithOutput<U>).output
		}
		else {
			let group = DispatchGroup()
			group.enter()

			promise!({
				self.output = $0
				group.leave()
			}, {
				self.catchError?($0)
				group.leave()
			})

			group.wait()
		}
	}

}
