//
//  BankCardNumberTextInputSerializerTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 10/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

class BankCardNumberTextInputSerializerTests: XCTestCase {

    let serializer = TextInputFormats.bankCardNumber().serializer

    func testThatSerializerWorksCorrectly() {
        for sampleCardNumber in BankCardNumberTestDataSet.cardNumbers {
            let bankCardNumber = BankCardNumber(digitsString: sampleCardNumber.digitsString)
            XCTAssertEqual(serializer.string(for: bankCardNumber), sampleCardNumber.formattedString)
            XCTAssertEqual(try? serializer.value(for: sampleCardNumber.formattedString), bankCardNumber)
        }
    }

    // TODO: Implement.
//    func testThatSerializerRaisesFatalErrorForInvalidString() {
//        let sampleStrings: [String] = [
//            "A",
//            "a",
//            "-",
//            "\n",
//        ]
//        for sampleString in sampleStrings {
//            expectFatalError {
//                _ = try! serializer.value(for: sampleString)
//            }
//        }
//    }

}
