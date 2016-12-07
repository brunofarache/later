extension Promise {

	 public func all<U>(_ block: (T) -> (U?)...) -> Promise<[U?]> {
		var blocks: [(T?) -> U?] = []

		for b in block {
			blocks.append({ input in
				return b(input!)
			})
		}

		addDependency(operation: AllOperation(blocks))

		return Promise<[U?]>(self.operations)
	}

}
