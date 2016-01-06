import Foundation

class Operation : NSOperation {

	var `catch`: ((NSError) -> ())?
	var output: Any?

}