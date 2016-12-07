import Foundation

class BlockTupleOperation<T,U>: OperationWithOutput<U> {

	var block: (T?) -> (U?, Error?)

	init(_ block: @escaping (T?) -> (U?, Error?)) {
		self.block = block
	}

	override func main() {
		let operation = dependencies.last as? OperationWithOutput<T>
		let output = block(operation?.output)

		if let error = output.1 {
			catchError?(error)
		}
		else {
			self.output = output.0
		}
	}

}
