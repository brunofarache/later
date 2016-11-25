import Foundation

class BlockTupleOperation : Operation {

	var block: (Any?) -> (Any?, Error?)

	init(_ block: @escaping (Any?) -> (Any?, Error?)) {
		self.block = block
	}

	override func main() {
		let operation = dependencies.last as? Operation
		let output = block(operation?.output)

		if let error = output.1 {
			catchError?(error)
		}
		else {
			self.output = output.0
		}
	}

}
