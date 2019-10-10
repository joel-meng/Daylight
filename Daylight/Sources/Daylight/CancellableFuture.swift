//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

