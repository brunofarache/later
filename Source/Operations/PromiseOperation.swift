import Foundation

class PromiseOperation : Operation {

	var block: ((Any?) -> (((Any?) -> (), (NSError) -> ()) -> ()))?
	var promise: (((Any?) -> (), (NSError) -> ()) -> ())?

	init(promise: @escaping (((Any?) -> (), (NSError) -> ()) -> ())) {
		self.promise = promise
	}

	init(block: @escaping (Any?) -> (((Any?) -> (), (NSError) -> ()) -> ())) {
		self.block = block
	}

	override func main() {
		let group = DispatchGroup()
		group.enter()

		if let b = block, let op = dependencies.last as? Operation {
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
