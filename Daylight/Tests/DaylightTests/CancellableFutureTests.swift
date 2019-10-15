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

import XCTest
@testable import Daylight

class CancellableFutureTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

	// MARK: - Creation

	func testCancellableFutureCreationInitialState() {
		let cancellableFuture = CancellableFuture<Int>()

		XCTAssertFalse(cancellableFuture.isCancelled)
		XCTAssertNil(cancellableFuture.cancelAction)
	}

	// MARK: - Cancellations variations

	func testCancellableFutureCancelledAfterObserverSet() {
		let cancellableFuture = CancellableFuture<Int>()

		expect("Failure called with FutureError.cancelled", { (expectation: XCTestExpectation) in
			cancellableFuture.on(success: { _ in
				XCTFail("Never should be called.")
			}, failure: { error in
				XCTAssertEqual((error as! FutureError), FutureError.cancelled)
				expectation.fulfill()
			})
			cancellableFuture.cancel()
		}, fulfillmentCount: 1)
	}

	func testCancellableFutureCancelledAfterObserverSetWithOnlySuccessListening() {
		let cancellableFuture = CancellableFuture<Int>()

		expectNotHappen("", { _ in
			cancellableFuture.onSuccess { (_) in
				XCTFail("Never should be called.")
			}
			cancellableFuture.cancel()
		})
	}

	func testCancellableFutureCancelledBeforeObserverSet() {
		let cancellableFuture = CancellableFuture<Int>()

		expect("Failure called with FutureError.cancelled", { (expectation: XCTestExpectation) in
			cancellableFuture.cancel()

			cancellableFuture.on(success: { _ in
				expectation.fulfill()
				XCTFail("Never should be called.")
			}, failure: { error in
				XCTAssertEqual((error as! FutureError), FutureError.cancelled)
				expectation.fulfill()
			})
		}, fulfillmentCount: 1)
	}

	func testCancellableFutureCancelledBeforeObserverSetWithOnlySuccessListening() {
		let cancellableFuture = CancellableFuture<Int>()

		expectNotHappen("", { _ in
			cancellableFuture.cancel()
			cancellableFuture.onSuccess { (_) in
				XCTFail("Never should be called.")
			}
		})
	}

	// MARK: - Mutiple cancellations

	func testCancellableFutureCancelledMultipleTimesAfterObserverSet() {
		let cancellableFuture = CancellableFuture<Int>()
		expect("Failure called with FutureError.cancelled", { (expectation: XCTestExpectation) in
			cancellableFuture.on(success: { _ in
				XCTFail("Never should be called.")
			}, failure: { error in
				XCTAssertEqual((error as! FutureError), FutureError.cancelled)
				expectation.fulfill()
			})
			cancellableFuture.cancel()
			cancellableFuture.cancel()
			cancellableFuture.cancel()
		}, fulfillmentCount: 1)
	}

	func testCancellableFutureCancelledMultipleTimesBeforeObserverSet() {
		let cancellableFuture = CancellableFuture<Int>()

		expect("Failure called with FutureError.cancelled", { (expectation: XCTestExpectation) in
			cancellableFuture.cancel()
			cancellableFuture.cancel()
			cancellableFuture.cancel()

			cancellableFuture.on(success: { _ in
				expectation.fulfill()
				XCTFail("Never should be called.")
			}, failure: { error in
				XCTAssertEqual((error as! FutureError), FutureError.cancelled)
				expectation.fulfill()
			})
		}, fulfillmentCount: 1)
	}

	func testCancellableFutureCancelledBeforeAndAfter() {
		let cancellableFuture = CancellableFuture<Int>()

		expect("Failure called with FutureError.cancelled", { (expectation: XCTestExpectation) in
			cancellableFuture.cancel()
			cancellableFuture.on(success: { _ in
				XCTFail("Never should be called.")
			}, failure: { error in
				XCTAssertEqual((error as! FutureError), FutureError.cancelled)
				expectation.fulfill()
			})
			cancellableFuture.cancel()
		}, fulfillmentCount: 1)
	}

	func testCancellableFutureCancelledBeforeAndAfterWithOnlySuccessListener() {
		let cancellableFuture = CancellableFuture<Int>()

		expectNotHappen("Failure called with FutureError.cancelled", { _ in
			cancellableFuture.cancel()
			cancellableFuture.onSuccess { (_) in
				XCTFail("Never should be called.")
			}
			cancellableFuture.cancel()
		})
	}

	// MARK: - Cancel state

	func testCancelState() {
		let future = CancellableFuture<Int>()
		future.cancel()
		XCTAssertTrue(future.isCancelled)
	}
}
