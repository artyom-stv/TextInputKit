//
//  BankCardNumberTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 10/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

class BankCardNumberTests: XCTestCase {

    func testThatPublicInitializerWorksCorrectly() {
        for sampleCardNumber in BankCardNumberTestDataSet.cardNumbers {
            XCTAssertTrue(BankCardNumber(digitsString: sampleCardNumber.digitsString) == sampleCardNumber)
        }
    }

    func testThatInternalInitializerWorksCorrectly() {
        for sampleCardNumber in BankCardNumberTestDataSet.cardNumbers {
            XCTAssertTrue(BankCardNumber(formattedString: sampleCardNumber.formattedString) == sampleCardNumber)
        }
    }

    // TODO: Implement.
//    func testThatPublicInitializerRaisesFatalErrorForInvalidString() {
//        let sampleStrings: [String] = [
//            "A",
//            "a",
//            "-",
//            "\n",
//            ]
//        for sampleString in sampleStrings {
//            expectFatalError {
//                _ = BankCardNumber(digitsString: sampleString)
//            }
//        }
//    }

}
