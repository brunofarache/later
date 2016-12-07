import Foundation

class BlockOperation<T,U> : OperationWithOutput<U> {

	var block: ((T?) -> (U?))

	init(_ block: @escaping (T?) -> (U?)) {
		self.block = block
	}

	override func main() {
		let operation = dependencies.last as? OperationWithOutput<T>
		output = block(operation?.output)
	}

}
