//
//  BankCardNumberTextInputFormatterTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 02/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

class BankCardNumberTextInputFormatterTests: XCTestCase {

    let textInputFormatter = BankCardNumberTextInputFormatter(.options())

    var textInput: TextInputSimulator!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator(textInputFormatter)
    }

    func testThatUatpCardIsFormattedCorrectly() {
        textInput.insert("122000000000003")
        textInput.expect("1220 00000 000003", "", "")
    }

    func testThatAmexCardIsFormattedCorrectly() {
        textInput.insert("378282246310005")
        textInput.expect("3782 822463 10005", "", "")
    }

    func testThatVisaCardIsFormattedCorrectly() {
        textInput.insert("4111111111111111")
        textInput.expect("4111 1111 1111 1111", "", "")
    }

    func testThatMasterCardCardIsFormattedCorrectly() {
        textInput.insert("5454545454545454")
        textInput.expect("5454 5454 5454 5454", "", "")
    }

    func testThatTypingIsFormattedCorrectly() {
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
    }

    func testThatPressingBackspaceIsFormattedCorrectly() {
        textInput.insert("378282246310005")
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
            textInput.selectAll()
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
        textInput.insert("41111111111111")
        textInput.expect("4111 1111 1111 11", "", "")

        textInput.select(0..<0)
        textInput.insert("3")
        textInput.expect("3", "", "411 111111 11111")
    }

    func testThatFormatterAcceptsAppendingTextWhenPossible() {
        typealias TestData = (string: String, appending: String)

        let testDataSet: [TestData] = [
            (string: "3", appending: "7"),
            (string: "37", appending: "8"),
            (string: "378", appending: "2"),
            (string: "3782 8", appending: "2"),
            (string: "3782 82", appending: "2"),
            (string: "3782 822", appending: "4"),
            (string: "3782 8224", appending: "6"),
            (string: "3782 82246", appending: "3"),
            (string: "3782 822463 1", appending: "0"),
            (string: "3782 822463 10", appending: "0"),
            (string: "3782 822463 100", appending: "0"),
            (string: "3782 822463 1000", appending: "5"),
        ]

        for testData in testDataSet {
            let string = testData.string
            let replacementString = testData.appending
            let selectedRange = string.endIndex..<string.endIndex

            let validationResult = textInputFormatter.validate(
                editing: string,
                withSelection: selectedRange,
                replacing: replacementString,
                at: selectedRange)

            XCTAssertEqual(validationResult, .accepted)
        }
    }

    func testThatFormatterAcceptsInsertingTextWhenPossible() {
        typealias TestData = (stringPrefix: String, inserting: String, stringSuffix: String)

        let testDataSet: [TestData] = [
            (stringPrefix: "", inserting: "3", stringSuffix: "782"),
            (stringPrefix: "3", inserting: "7", stringSuffix: "82"),
            (stringPrefix: "37", inserting: "8", stringSuffix: "2"),
            (stringPrefix: "3782 8", inserting: "2", stringSuffix: "2463"),
            (stringPrefix: "3782 82", inserting: "2", stringSuffix: "463"),
            (stringPrefix: "3782 822", inserting: "4", stringSuffix: "63"),
            (stringPrefix: "3782 8224", inserting: "6", stringSuffix: "3"),
            (stringPrefix: "3782 822463 1", inserting: "0", stringSuffix: "005"),
            (stringPrefix: "3782 822463 10", inserting: "0", stringSuffix: "05"),
            (stringPrefix: "3782 822463 100", inserting: "0", stringSuffix: "5"),
            ]

        for testData in testDataSet {
            let string = testData.stringPrefix.appending(testData.stringSuffix)
            let replacementString = testData.inserting
            let selectedRange: Range<String.Index> = {
                let index = string.index(string.startIndex, offsetBy: testData.stringPrefix.characters.count)
                return index..<index
            }()

            let validationResult = textInputFormatter.validate(
                editing: string,
                withSelection: selectedRange,
                replacing: replacementString,
                at: selectedRange)

            XCTAssertEqual(validationResult, .accepted)
        }
    }

}
