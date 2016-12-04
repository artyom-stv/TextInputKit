//
//  MutableBoxTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 27/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

class MutableBoxTests: XCTestCase {

    let sampleValue = 123
    let otherSampleValue = 234

    func testThatInitialValueIsStored() {
        let box = MutableBox(sampleValue)
        XCTAssertEqual(box.value, sampleValue)
    }

    func testThatChangedValueIsStored() {
        let box = MutableBox(sampleValue)
        box.value = otherSampleValue
        XCTAssertEqual(box.value, otherSampleValue)
    }

    func testThatBoxCanBeShared() {
        let box = MutableBox(sampleValue)
        let box2 = box
        box.value = otherSampleValue
        XCTAssertEqual(box.value, box2.value)
    }

}
