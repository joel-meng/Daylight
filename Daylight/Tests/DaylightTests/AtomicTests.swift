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

class AtomicTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

	// MARK: - Initialization

	func testInitiliazing() {
		let atomic = Atomic<Int>(10)
		XCTAssertEqual(atomic.value, 10)
	}

	// MARK: - Preformance Tests

    func testAtomicWrite() {
		var atomic = Atomic<Int>(0)

		self.measure {
			atomic.value { $0 = 0}

			DispatchQueue.concurrentPerform(iterations: 100_000) { _ in
				atomic.value { $0 += 1; return }
			}
		}

		XCTAssertEqual(atomic.value, 100_000)
    }

    func testAtomicAccationalReading() {
		var atomic = Atomic<Int>(0)

		self.measure {
			atomic.value { $0 = 0}

			DispatchQueue.concurrentPerform(iterations: 100_000) { it in
				XCTAssertGreaterThanOrEqual(atomic.value, 0)
				if it.isMultiple(of: 100) {
					atomic.value { $0 += 1 }
				}
			}
		}

		XCTAssertEqual(atomic.value, 1_000)
    }

	func testAtomicIntensiveWritingWithReading() {
		var atomic = Atomic<Int>(0)

		self.measure {
			atomic.value { $0 = 0}

			DispatchQueue.concurrentPerform(iterations: 100_000) { it in
				XCTAssertGreaterThanOrEqual(atomic.value, 0)
				if it.isMultiple(of: 10) {
					atomic.value { $0 += 1 }
				}
			}
		}

		XCTAssertEqual(atomic.value, 10_000)
    }
}
