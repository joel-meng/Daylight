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
			cancellableFuture.on(success: { futureValue in
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

		expectNotHappen("", { (expectation: XCTestExpectation) in
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

			cancellableFuture.on(success: { futureValue in
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

		expectNotHappen("", { (expectation: XCTestExpectation) in
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
			cancellableFuture.on(success: { futureValue in
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

			cancellableFuture.on(success: { futureValue in
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
			cancellableFuture.on(success: { futureValue in
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

		expectNotHappen("Failure called with FutureError.cancelled", { (expectation: XCTestExpectation) in
			cancellableFuture.cancel()
			cancellableFuture.onSuccess { (_) in
				XCTFail("Never should be called.")
				expectation.fulfill()
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
