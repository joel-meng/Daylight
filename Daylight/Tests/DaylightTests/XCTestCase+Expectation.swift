//
//  XCTestCase+Expectation.swift
//  LightTests
//
//  Created by Joel Meng on 10/9/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import XCTest

extension XCTestCase {

	func expect(_ _expectation: String, _ willHappen: (XCTestExpectation) -> Void, within time: TimeInterval = 0.2, fulfillmentCount : Int = 1) {
		let exp = expectation(description: _expectation)
		exp.expectedFulfillmentCount = fulfillmentCount 
		willHappen(exp)
		waitForExpectations(timeout: time) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}

	func expectNotHappen(_ _expectation: String,
					   _ willNotHappen: (XCTestExpectation) -> Void,
					   within time: TimeInterval = 0.5) {
		let exp = expectation(description: _expectation)
		exp.isInverted = true
		willNotHappen(exp)
		waitForExpectations(timeout: time) { (error) in
			XCTAssertNil(error)
		}
	}
}
