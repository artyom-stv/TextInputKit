//
//  BankCardExpiryDateTextInputFormatterTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 20/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

final class BankCardExpiryDateTextInputFormatterTests: XCTestCase {

    let textInputFormat = TextInputFormats.bankCardExpiryDate()

    var textInput: TextInputSimulator!

    var textInputBinding: TextInputBinding<BankCardExpiryDate>!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator()
        textInputBinding = textInputFormat.bind(to: textInput)
    }

    func testThatTypingIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("1")
            textInput.expect("1", "", "")
            editor.insert("2")
            textInput.expect("12/", "", "")
            editor.insert("3")
            textInput.expect("12/3", "", "")
            editor.insert("4")
            textInput.expect("12/34", "", "")
        }
    }

    func testThatPressingBackspaceIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("12/34")
            textInput.expect("12/34", "", "")
        }

        textInput.edit { editor in
            editor.backspace()
            textInput.expect("12/3", "", "")
            editor.backspace()
            textInput.expect("12/", "", "")
            editor.backspace()
            textInput.expect("1", "", "")
            editor.backspace()
            textInput.expect("", "", "")
        }
    }

    func testThatEditingMonthIsFormattedCorrectly() {
        let initialSelectionCases: [Range<Int>] = [
            2..<2,
            3..<3
        ]
        for initialSelection in initialSelectionCases {
            textInput.edit { editor in
                editor.insert("12/34")
                textInput.expect("12/34", "", "")
            }

            textInput.edit { editor in
                editor.select(initialSelection)
                editor.backspace()
                textInput.expect("1", "", "/34")
                editor.backspace()
                textInput.expect("", "", "/34")

                editor.insert("1")
                textInput.expect("1", "", "/34")
                editor.insert("2")
                textInput.expect("12", "", "/34")

                editor.select(1..<1)
                editor.backspace()
                textInput.expect("", "", "2/34")
                editor.insert("1")
                textInput.expect("1", "", "2/34")
            }
        }
    }

    func testThatEditingYearIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("12/34")
            textInput.expect("12/34", "", "")
        }

        textInput.edit { editor in
            editor.select(4..<4)
            textInput.expect("12/3", "", "4")
            editor.backspace()
            textInput.expect("12/", "", "4")
            editor.insert("3")
            textInput.expect("12/3", "", "4")
        }
    }

    func testThatEditingMonthWithIncompleteYearIsFormattedCorrectly() {
        let initialSelectionCases: [Range<Int>] = [
            2..<2,
            3..<3
        ]
        for initialSelection in initialSelectionCases {
            textInput.edit { editor in
                editor.insert("12/4")
                textInput.expect("12/4", "", "")
            }

            textInput.edit { editor in
                editor.select(initialSelection)
                editor.backspace()
                textInput.expect("1", "", "/4")
                editor.backspace()
                textInput.expect("", "", "/4")

                editor.insert("1")
                textInput.expect("1", "", "/4")
                editor.insert("2")
                textInput.expect("12", "", "/4")

                editor.select(1..<1)
                editor.backspace()
                textInput.expect("", "", "2/4")
                editor.insert("1")
                textInput.expect("1", "", "2/4")
            }
        }
    }

    func testThatInsertingExcessDigitsInMonthIsRejected() {
        let yearCases: [String] = [
            "34",
            "4"
        ]
        for year in yearCases {
            textInput.edit { editor in
                editor.selectAll()
                editor.insert("12/\(year)")
                textInput.expect("12/\(year)", "", "")
            }

            textInput.edit { editor in
                editor.select(0..<0)
                editor.insert("0")
                textInput.expect("", "", "12/\(year)")

                editor.select(1..<1)
                editor.insert("0")
                textInput.expect("1", "", "2/\(year)")

                editor.select(2..<2)
                editor.insert("0")
                textInput.expect("12", "", "/\(year)")
            }
        }
    }

    func testThatInsertingExcessDigitsInYearIsRejected() {
        let monthCases: [String] = [
            "12",
            "1"
        ]
        for month in monthCases {
            textInput.edit { editor in
                editor.selectAll()
                editor.insert("\(month)/34")
                textInput.expect("\(month)/34", "", "")
            }

            textInput.edit { editor in
                var i = month.count + 1
                editor.select(i..<i)
                editor.insert("0")
                textInput.expect("\(month)/", "", "34")

                i = i + 1
                editor.select(i..<i)
                editor.insert("0")
                textInput.expect("\(month)/3", "", "4")

                i = i + 1
                editor.select(i..<i)
                editor.insert("0")
                textInput.expect("\(month)/34", "", "")
            }
        }
    }

    func testThatEditingOneDigitSelectionIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("12/34")
            textInput.expect("12/34", "", "")
        }

        textInput.edit { editor in
            editor.select(0..<1)
            editor.insert("5")
            textInput.expect("5", "", "2/34")

            editor.select(1..<2)
            editor.insert("6")
            textInput.expect("56", "", "/34")

            editor.select(3..<4)
            editor.insert("7")
            textInput.expect("56/7", "", "4")

            editor.select(4..<5)
            editor.insert("8")
            textInput.expect("56/78", "", "")
        }
    }

    func testThatEditingSelectedSlashIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("12/")
            textInput.expect("12/", "", "")
        }

        textInput.edit { editor in
            editor.select(2..<3)
            editor.insert("0")
            textInput.expect("12", "/", "")

            editor.select(3..<3)
            editor.insert("3")
            textInput.expect("12/3", "", "")
            editor.select(2..<3)
            editor.insert("0")
            textInput.expect("12", "/", "3")
        }
    }

}
