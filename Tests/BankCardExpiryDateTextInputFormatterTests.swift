//
//  BankCardExpiryDateTextInputFormatterTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 20/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

final class BankCardExpiryDateTextInputFormatterTests : XCTestCase {

    let textInputFormatter = BankCardNumberTextInputFormatter(.options())

    var textInput: TextInputSimulator!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator(textInputFormatter)
    }

    func testThatTypingIsFormattedCorrectly() {
        textInput.insert("1")
        textInput.expect("1", "", "")
        textInput.insert("2")
        textInput.expect("12/", "", "")
        textInput.insert("3")
        textInput.expect("12/3", "", "")
        textInput.insert("4")
        textInput.expect("12/34", "", "")
    }

    func testThatPressingBackspaceIsFormattedCorrectly() {
        textInput.insert("12/34")
        textInput.expect("12/34", "", "")

        textInput.backspace()
        textInput.expect("12/3", "", "")
        textInput.backspace()
        textInput.expect("12/", "", "")
        textInput.backspace()
        textInput.expect("1", "", "")
        textInput.backspace()
        textInput.expect("", "", "")
    }

    func testThatEditingMonthIsFormattedCorrectly() {
        let initialSelectionCases: [Range<Int>] = [
            2..<2,
            3..<3
        ]
        for initialSelection in initialSelectionCases {
            textInput.selectAll()
            textInput.insert("12/34")
            textInput.expect("12/34", "", "")

            textInput.select(initialSelection)
            textInput.backspace()
            textInput.expect("1", "", "/34")
            textInput.backspace()
            textInput.expect("", "", "/34")

            textInput.insert("1")
            textInput.expect("1", "", "/34")
            textInput.insert("2")
            textInput.expect("12", "", "/34")

            textInput.select(1..<1)
            textInput.backspace()
            textInput.expect("", "", "2/34")
            textInput.insert("1")
            textInput.expect("1", "", "2/34")
        }
    }

    func testThatEditingYearIsFormattedCorrectly() {
        textInput.insert("12/34")
        textInput.expect("12/34", "", "")

        textInput.select(4..<4)
        textInput.expect("12/3", "", "4")
        textInput.backspace()
        textInput.expect("12/", "", "4")
        textInput.insert("3")
        textInput.expect("12/3", "", "4")
    }

    func testThatEditingMonthWithIncompleteYearIsFormattedCorrectly() {
        let initialSelectionCases: [Range<Int>] = [
            2..<2,
            3..<3
        ]
        for initialSelection in initialSelectionCases {
            textInput.selectAll()
            textInput.insert("12/4")
            textInput.expect("12/4", "", "")

            textInput.select(initialSelection)
            textInput.backspace()
            textInput.expect("1", "", "/4")
            textInput.backspace()
            textInput.expect("", "", "/4")

            textInput.insert("1")
            textInput.expect("1", "", "/4")
            textInput.insert("2")
            textInput.expect("12", "", "/4")

            textInput.select(1..<1)
            textInput.backspace()
            textInput.expect("", "", "2/4")
            textInput.insert("1")
            textInput.expect("1", "", "2/4")
        }
    }

    func testThatInsertingExcessDigitsInMonthIsRejected() {
        let yearCases: [String] = [
            "34",
            "4"
        ]
        for year in yearCases {
            textInput.insert("12/\(year)")
            textInput.expect("12/\(year)", "", "")

            textInput.select(0..<0)
            textInput.insert("0")
            textInput.expect("", "", "12/\(year)")

            textInput.select(1..<1)
            textInput.insert("0")
            textInput.expect("1", "", "2/\(year)")

            textInput.select(2..<2)
            textInput.insert("0")
            textInput.expect("12", "", "/\(year)")
        }
    }

    func testThatInsertingExcessDigitsInYearIsRejected() {
        let monthCases: [String] = [
            "12",
            "1"
        ]
        for month in monthCases {
            textInput.insert("\(month)/34")
            textInput.expect("\(month)/34", "", "")

            var i = month.characters.count
            textInput.select(i..<i)
            textInput.insert("0")
            textInput.expect("\(month)/", "", "34")

            i = i + 1
            textInput.select(i..<i)
            textInput.insert("0")
            textInput.expect("\(month)/3", "", "4")

            i = i + 1
            textInput.select(i..<i)
            textInput.insert("0")
            textInput.expect("\(month)/34", "", "")
        }
    }

    func testThatEditingOneDigitSelectionIsFormattedCorrectly() {
        textInput.insert("12/34")
        textInput.expect("12/34", "", "")

        textInput.select(0..<1)
        textInput.insert("5")
        textInput.expect("5", "", "2/34")

        textInput.select(1..<2)
        textInput.insert("6")
        textInput.expect("56", "", "/34")

        textInput.select(3..<4)
        textInput.insert("7")
        textInput.expect("56/7", "", "4")

        textInput.select(4..<5)
        textInput.insert("8")
        textInput.expect("56/78", "", "")
    }

    func testThatEditingSelectedSlashIsFormattedCorrectly() {
        textInput.insert("12/")
        textInput.expect("12/", "", "")

        textInput.select(2..<3)
        textInput.insert("0")
        textInput.expect("12/", "", "")

        textInput.insert("3")
        textInput.expect("12/3", "", "")
        textInput.select(2..<3)
        textInput.insert("0")
        textInput.expect("12/", "", "3")
    }

    func testThatEditingSelectedSlashAndMonthIsFormattedCorrectly() {
        textInput.insert("12/34")
        textInput.expect("12/34", "", "")

        textInput.select(1..<3)
        textInput.insert("5")
        textInput.expect("15", "", "/34")

        textInput.select(1..<4)
        textInput.insert("6")
        textInput.expect("16", "", "/34")
    }

    func testThatEditingSelectedSlashAndYearIsFormattedCorrectly() {
        textInput.insert("12/34")
        textInput.expect("12/34", "", "")

        textInput.select(2..<4)
        textInput.insert("5")
        textInput.expect("12/5", "", "4")
    }

}
