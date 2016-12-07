import Foundation

class PromiseOperation<T,U> : OperationWithOutput<U> {

	var block: ((T?) -> PromiseClosure<U>)?
	var promise: (PromiseClosure<U>)?

	init(promise: @escaping PromiseClosure<U>) {
		self.promise = promise
	}

	init(block: @escaping (T?) -> PromiseClosure<U>) {
		self.block = block
	}

	override func main() {
		let group = DispatchGroup()
		group.enter()

		if let b = block, let op = dependencies.last as? OperationWithOutput<T> {
			promise = b(op.output)
		}

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
