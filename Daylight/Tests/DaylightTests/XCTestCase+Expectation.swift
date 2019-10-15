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

extension XCTestCase {

	func expect(_ _expectation: String, _ willHappen: (XCTestExpectation) -> Void, within time: TimeInterval = 0.3, fulfillmentCount: Int = 1) {
		let exp = expectation(description: _expectation)
		exp.expectedFulfillmentCount = fulfillmentCount
		willHappen(exp)
		waitForExpectations(timeout: time) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}

	func expectNotHappen(_ _expectation: String, _ willNotHappen: (XCTestExpectation) -> Void, within time: TimeInterval = 0.5) {
		let exp = expectation(description: _expectation)
		exp.isInverted = true
		willNotHappen(exp)
		waitForExpectations(timeout: time) { (error) in
			XCTAssertNil(error)
		}
	}
}
