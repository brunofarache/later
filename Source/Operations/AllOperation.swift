import Foundation

class AllOperation<T, U> : OperationWithOutput<[U?]> {

	var blocks: [(T?) -> (U?)]

	init(_ block: [(T?) -> (U?)]) {
		self.blocks = block
	}

	override func main() {
		var results = [U?](repeating: nil, count: self.blocks.count)
		let operation = dependencies.last as? OperationWithOutput<T>

		let group = DispatchGroup()
		let queue = DispatchQueue.global()

		for (i, block) in blocks.enumerated() {
			queue.async(group: group) {
				results[i] = block(operation?.output)
			}
		}

		group.wait()

		output = results
	}

}
