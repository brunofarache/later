import Foundation

class PromiseOperation : Operation {

	var block: ((Any?) -> PromiseClosure)?
	var promise: ((_ fulfill: @escaping (Any) -> Void, _ reject: @escaping (NSError) -> Void) -> Void)?

	init(promise: @escaping (_ fulfill: @escaping (Any) -> Void, _ reject: @escaping (NSError) -> Void) -> Void) {
		self.promise = promise
	}

	init(block: @escaping (Any?) -> (PromiseClosure)) {
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
