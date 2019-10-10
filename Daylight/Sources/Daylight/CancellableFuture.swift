/*
MIT License

Copyright (c) 2019 Daylight

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

/// A protocol defines `FutureObserver` who can be cancelled.
public protocol Cancellable {

	/// Update `Future` object with a cancel action which will be called once `cancel` is called
	/// - Parameter action: A function that tells `Future` object how to cancel a `Future` value been sent.
	/// 					A error `FutureError.cancelled` will be sent to observers.
	var cancelAction: (() -> Void)? { set get }

	/// Function to cancel a `Future`. When a `Future` been cancelled, a error `FutureError.cancelled` will be sent to
	/// listeners and no more value or error will be received by listeners.
	func cancel()

	/// `True` if marked as `cancelled`, else false.
	var isCancelled: Bool { get }
}

/// A subclass of `Future` which has the capability to cancel a ongoing
final public class CancellableFuture<Value>: Cancellable, FutureObserver, FutureUpdater {

	public var cancelAction: (() -> Void)?

	public private(set) var isCancelled: Bool = false {
		willSet {
			if isCancelled == true {
				return
			}

			if newValue == true {
				reject(with: FutureError.cancelled)
			}
		}
	}

	private let futureDelegate: Future<Value>

	public init() {
		self.futureDelegate = Future<Value>()
	}

	// MARK: - Cancellable

	public func cancel() {

		cancelAction?()

		isCancelled = true
	}

	// MARK: - FutureObserver

	public func onSuccess(_ successCallback: @escaping (Value) -> Void) {
		futureDelegate.onSuccess(successCallback)
	}

	public func on(success successCallback: @escaping (Value) -> Void,
				   failure failureCallback: ((Error) -> Void)?) {
		futureDelegate.on(success: successCallback, failure: failureCallback)
	}

	// MARK: - FutureUpdater

	public func resolve(with value: Value) {
		futureDelegate.resolve(with: value)
	}

	public func reject(with error: Error) {
		futureDelegate.reject(with: error)
	}
}

public enum FutureError: Error {
	case cancelled
}

extension FutureError: Equatable {
	public static func ==(lhs: FutureError, rhs: FutureError) -> Bool {
		switch(lhs, rhs) {
		case (cancelled, cancelled):
			return true
		}
	}
}

