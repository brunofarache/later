import Foundation

class AllOperation : Operation {

	var blocks: [(Any?) -> (Any?)]

	init(_ block: [(Any?) -> (Any?)]) {
		self.blocks = block
	}

	override func main() {
		var results = [Any?](repeating: nil, count: self.blocks.count)
		let operation = dependencies.last as? Operation

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
