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

    let textInputFormat = TextInputFormats.bankCardNumber()

    var textInput: TextInputSimulator!

    var textInputBinding: TextInputBinding<BankCardNumber>!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator()
        textInputBinding = textInputFormat.bind(to: textInput)
    }

    func testThatUatpCardIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("122000000000003")
            textInput.expect("1220 00000 000003", "", "")
        }
    }

    func testThatAmexCardIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("378282246310005")
            textInput.expect("3782 822463 10005", "", "")
        }
    }

    func testThatVisaCardIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("4111111111111111")
            textInput.expect("4111 1111 1111 1111", "", "")
        }
    }

    func testThatMasterCardCardIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("5454545454545454")
            textInput.expect("5454 5454 5454 5454", "", "")
        }
    }

    func testThatTypingIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("3")
            textInput.expect("3", "", "")
            editor.insert("7")
            textInput.expect("37", "", "")
            editor.insert("8")
            textInput.expect("378", "", "")
            editor.insert("2")
            textInput.expect("3782", "", "")
            editor.insert("8")
            textInput.expect("3782 8", "", "")
            editor.insert("2")
            textInput.expect("3782 82", "", "")
            editor.insert("2")
            textInput.expect("3782 822", "", "")
            editor.insert("4")
            textInput.expect("3782 8224", "", "")
            editor.insert("6")
            textInput.expect("3782 82246", "", "")
            editor.insert("3")
            textInput.expect("3782 822463", "", "")
            editor.insert("1")
            textInput.expect("3782 822463 1", "", "")
            editor.insert("0")
            textInput.expect("3782 822463 10", "", "")
            editor.insert("0")
            textInput.expect("3782 822463 100", "", "")
            editor.insert("0")
            textInput.expect("3782 822463 1000", "", "")
            editor.insert("5")
            textInput.expect("3782 822463 10005", "", "")
        }
    }

    func testThatPressingBackspaceIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("378282246310005")
            textInput.expect("3782 822463 10005", "", "")
        }

        textInput.edit { editor in
            editor.backspace()
            textInput.expect("3782 822463 1000", "", "")
            editor.backspace()
            textInput.expect("3782 822463 100", "", "")
            editor.backspace()
            textInput.expect("3782 822463 10", "", "")
            editor.backspace()
            textInput.expect("3782 822463 1", "", "")
            editor.backspace()
            textInput.expect("3782 822463", "", "")
            editor.backspace()
            textInput.expect("3782 82246", "", "")
            editor.backspace()
            textInput.expect("3782 8224", "", "")
            editor.backspace()
            textInput.expect("3782 822", "", "")
            editor.backspace()
            textInput.expect("3782 82", "", "")
            editor.backspace()
            textInput.expect("3782 8", "", "")
            editor.backspace()
            textInput.expect("3782", "", "")
            editor.backspace()
            textInput.expect("378", "", "")
            editor.backspace()
            textInput.expect("37", "", "")
            editor.backspace()
            textInput.expect("3", "", "")
            editor.backspace()
            textInput.expect("", "", "")
        }
    }

    func testThatChangesWithSelectionAreFormattedCorrectly() {
        func test(_ actions: (TextInputSimulator, TextInputSimulator.Editor) -> ()) {
            textInput.edit { editor in
                editor.selectAll()
                editor.insert("378282246310005")
                textInput.expect("3782 822463 10005", "", "")
            }

            textInput.edit { editor in
                actions(textInput, editor)
            }
        }

        test { textInput, editor in
            editor.select(4..<5)
            textInput.expect("3782", " ", "822463 10005")
            editor.backspace()
            textInput.expect("3782", "", " 822463 10005")
        }

        test { textInput, editor in
            editor.select(11..<12)
            textInput.expect("3782 822463", " ", "10005")
            editor.backspace()
            textInput.expect("3782 822463", "", " 10005")
        }

        test { textInput, editor in
            editor.select(3..<5)
            textInput.expect("378", "2 ", "822463 10005")
            editor.insert("2")
            textInput.expect("3782", "", " 822463 10005")
        }

        test { textInput, editor in
            editor.select(4..<6)
            textInput.expect("3782", " 8", "22463 10005")
            editor.insert("8")
            textInput.expect("3782 8", "", "22463 10005")
        }

        test { textInput, editor in
            editor.select(10..<12)
            textInput.expect("3782 82246", "3 ", "10005")
            editor.insert("3")
            textInput.expect("3782 822463", "", " 10005")
        }

        test { textInput, editor in
            editor.select(11..<13)
            textInput.expect("3782 822463", " 1", "0005")
            editor.insert("1")
            textInput.expect("3782 822463 1", "", "0005")
        }
    }

    func testThatVisaIsReformattedToAmexAfterInsertingFirstDigit() {
        textInput.edit { editor in
            editor.insert("41111111111111")
            textInput.expect("4111 1111 1111 11", "", "")
        }

        textInput.edit { editor in
            editor.select(0..<0)
            editor.insert("3")
            textInput.expect("3", "", "411 111111 11111")
        }
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

            let validationResult = textInputFormat.formatter.validate(
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

            let validationResult = textInputFormat.formatter.validate(
                editing: string,
                withSelection: selectedRange,
                replacing: replacementString,
                at: selectedRange)

            XCTAssertEqual(validationResult, .accepted)
        }
    }

}
