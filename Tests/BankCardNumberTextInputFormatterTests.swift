//
//  BankCardNumberTextInputFormatterTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 02/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

private func textInputSimulator() -> TextInputSimulator {
    return TextInputSimulator(BankCardNumberTextInputFormatter(.options()))
}

class BankCardNumberTextInputFormatterTests: XCTestCase {

    func testThatUatpCardIsFormattedCorrectly() {
        let textInput = textInputSimulator()

        textInput.insert("122000000000003")
        textInput.expect("1220 00000 000003", "", "")
    }

    func testThatAmexCardIsFormattedCorrectly() {
        let textInput = textInputSimulator()

        textInput.insert("378282246310005")
        textInput.expect("3782 822463 10005", "", "")
    }

    func testThatVisaCardIsFormattedCorrectly() {
        let textInput = textInputSimulator()

        textInput.insert("4111111111111111")
        textInput.expect("4111 1111 1111 1111", "", "")
    }

    func testThatMasterCardCardIsFormattedCorrectly() {
        let textInput = textInputSimulator()

        textInput.insert("5454545454545454")
        textInput.expect("5454 5454 5454 5454", "", "")
    }

    func testThatTypingIsFormattedCorrectly() {
        let textInput = textInputSimulator()

        textInput.insert("3")
        textInput.expect("3", "", "")
        textInput.insert("7")
        textInput.expect("37", "", "")
        textInput.insert("8")
        textInput.expect("378", "", "")
        textInput.insert("2")
        textInput.expect("3782", "", "")
        textInput.insert("8")
        textInput.expect("3782 8", "", "")
        textInput.insert("2")
        textInput.expect("3782 82", "", "")
        textInput.insert("2")
        textInput.expect("3782 822", "", "")
        textInput.insert("4")
        textInput.expect("3782 8224", "", "")
        textInput.insert("6")
        textInput.expect("3782 82246", "", "")
        textInput.insert("3")
        textInput.expect("3782 822463", "", "")
        textInput.insert("1")
        textInput.expect("3782 822463 1", "", "")
        textInput.insert("0")
        textInput.expect("3782 822463 10", "", "")
        textInput.insert("0")
        textInput.expect("3782 822463 100", "", "")
        textInput.insert("0")
        textInput.expect("3782 822463 1000", "", "")
        textInput.insert("5")
        textInput.expect("3782 822463 10005", "", "")

        textInput.backspace()
        textInput.expect("3782 822463 1000", "", "")
        textInput.backspace()
        textInput.expect("3782 822463 100", "", "")
        textInput.backspace()
        textInput.expect("3782 822463 10", "", "")
        textInput.backspace()
        textInput.expect("3782 822463 1", "", "")
        textInput.backspace()
        textInput.expect("3782 822463", "", "")
        textInput.backspace()
        textInput.expect("3782 82246", "", "")
        textInput.backspace()
        textInput.expect("3782 8224", "", "")
        textInput.backspace()
        textInput.expect("3782 822", "", "")
        textInput.backspace()
        textInput.expect("3782 82", "", "")
        textInput.backspace()
        textInput.expect("3782 8", "", "")
        textInput.backspace()
        textInput.expect("3782", "", "")
        textInput.backspace()
        textInput.expect("378", "", "")
        textInput.backspace()
        textInput.expect("37", "", "")
        textInput.backspace()
        textInput.expect("3", "", "")
        textInput.backspace()
        textInput.expect("", "", "")
    }

    func testThatChangesWithSelectionAreFormattedCorrectly() {
        func test(_ actions: (TextInputSimulator) -> ()) {
            let textInput = textInputSimulator()
            textInput.insert("378282246310005")
            textInput.expect("3782 822463 10005", "", "")

            actions(textInput)
        }

        test { textInput in
            textInput.select(4..<5)
            textInput.expect("3782", " ", "822463 10005")
            textInput.backspace()
            textInput.expect("3782", "", " 822463 10005")
        }

        test { textInput in
            textInput.select(11..<12)
            textInput.expect("3782 822463", " ", "10005")
            textInput.backspace()
            textInput.expect("3782 822463", "", " 10005")
        }

        test { textInput in
            textInput.select(3..<5)
            textInput.expect("378", "2 ", "822463 10005")
            textInput.insert("2")
            textInput.expect("3782", "", " 822463 10005")
        }

        test { textInput in
            textInput.select(4..<6)
            textInput.expect("3782", " 8", "22463 10005")
            textInput.insert("8")
            textInput.expect("3782 8", "", "22463 10005")
        }

        test { textInput in
            textInput.select(10..<12)
            textInput.expect("3782 82246", "3 ", "10005")
            textInput.insert("3")
            textInput.expect("3782 822463", "", " 10005")
        }

        test { textInput in
            textInput.select(11..<13)
            textInput.expect("3782 822463", " 1", "0005")
            textInput.insert("1")
            textInput.expect("3782 822463 1", "", "0005")
        }
    }

    func testThatVisaIsReformattedToAmexAfterInsertingFirstDigit() {
        let textInput = textInputSimulator()

        textInput.insert("41111111111111")
        textInput.expect("4111 1111 1111 11", "", "")

        textInput.select(0..<0)
        textInput.insert("3")
        textInput.expect("3", "", "411 111111 11111")
    }

}
