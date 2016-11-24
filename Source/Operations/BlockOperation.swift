import Foundation

class BlockOperation : Operation {

	var block: ((Any?) -> (Any?))

	init(_ block: @escaping (Any?) -> (Any?)) {
		self.block = block
	}

	override func main() {
		let operation = dependencies.last as? Operation
		output = block(operation?.output)
	}

}