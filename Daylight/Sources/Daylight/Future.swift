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

typealias Promise<Input, Output> = (Input) -> Future<Output>

// MARK: - Future Updater

/// An protocol exposes to future updater functions that to tell a `Future` a value is ready or error happened.
public protocol FutureUpdater {

	associatedtype Value

	/// Tell `Future` that a value is ready
	/// - Parameter value: The value to pass to `Future`
	func resolve(with value: Value)

	/// Tell `Future` that no value found but an error happened.
	/// - Parameter error: The error to pass to `Future`
	func reject(with error: Error)
}

// MARK: - Future Observer

/// An protocol exposes functions to future listeners about `Future` result updated.
public protocol FutureObserver {

	associatedtype Value

	/// Add a listener for `Future`'s success values.
	/// - Parameter successCallback: A callback function that consumes success `Value` from `Future`
	func onSuccess(_ successCallback: @escaping (Value) -> Void)

	/// Add a listener for `Future`'s success values and failure error.
	/// - Parameter successCallback: A callback function that consumes success `Value` from `Future`
	/// - Parameter failureCallback: A callback function that consumes failure `Error` from `Future`
	func on(success successCallback: @escaping (Value) -> Void, failure failureCallback: ((Error) -> Void)?)
}


public class Future<Value>: FutureUpdater, FutureObserver {

	/// Listeners who is observing result's update
	lazy var listeners: [(Result<Value, Error>) -> Void] = []

	/// Result data that to be notified in future.
	var result: Result<Value, Error>? {
		didSet { result.map(notify) }
	}

	// MARK: - Initializer

	public init() {
	}

	public init(_ value: Value) {
		result = .success(value)
	}

	public init(error: Error) {
		result = .failure(error)
	}

	// MARK: - Listener notification

	private func notify(_ result: Result<Value, Error>) {
		listeners.forEach { $0(result) }
	}

	// MARK: - Listening

	public func onSuccess(_ successCallback: @escaping (Value) -> Void) {
		on(success: successCallback, failure: nil)
	}

	public func on(success successCallback: @escaping (Value) -> Void,
			failure failureCallback: ((Error) -> Void)?) {
		listeners.append({ (result) in
			switch result {
			case .success(let value):
				successCallback(value)
			case .failure(let error):
				failureCallback?(error)
			}
		})
		result.map(notify)
	}

	// MARK: - Result updating

	public func resolve(with value: Value) {
		result = .success(value)
	}

	public func reject(with error: Error) {
		result = .failure(error)
	}

	// MARK: - Functional

	func map<U>(_ f: @escaping (Value) -> U) -> Future<U> {
		let newFuture = Future<U>()
		on(success: { value in
			newFuture.resolve(with: f(value))
		}, failure: { error in
			newFuture.reject(with: error)
		})
		return newFuture
	}
}