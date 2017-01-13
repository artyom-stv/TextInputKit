//
//  PhoneNumberTextInputFormatterTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 12/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

final class PhoneNumberTextInputFormatterTests : XCTestCase {

    let textInputFormat = try! TextInputFormats.phoneNumber()

    var textInput: TextInputSimulator!

    var textInputBinding: TextInputBinding<PhoneNumber>!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator()
        textInputBinding = textInputFormat.bind(to: textInput)
    }

    func testThatTypingIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("+")
            textInput.expect("+", "", "")
            editor.insert("1")
            textInput.expect("+1", "", "")
            editor.insert("2")
            textInput.expect("+1 2", "", "")
            editor.insert("3")
            textInput.expect("+1 23", "", "")
            editor.insert("4")
            textInput.expect("+1 234", "", "")
            editor.insert("5")
            textInput.expect("+1 234-5", "", "")
            editor.insert("6")
            textInput.expect("+1 234-56", "", "")
            editor.insert("7")
            textInput.expect("+1 234-567", "", "")
            editor.insert("8")
            textInput.expect("+1 234-5678", "", "")
            editor.insert("9")
            textInput.expect("+1 (234) 567-89", "", "")
            editor.insert("0")
            textInput.expect("+1 (234) 567-890", "", "")
            editor.insert("1")
            textInput.expect("+1 (234) 567-8901", "", "")
        }
    }

    func testThatPressingBackspaceIsFormattedCorrectly() {
        textInput.edit { editor in
            editor.insert("+12345678901")
            textInput.expect("+1 (234) 567-8901", "", "")
        }

        textInput.edit { editor in
            editor.backspace()
            textInput.expect("+1 (234) 567-890", "", "")
            editor.backspace()
            textInput.expect("+1 (234) 567-89", "", "")
            editor.backspace()
            textInput.expect("+1 234-5678", "", "")
            editor.backspace()
            textInput.expect("+1 234-567", "", "")
            editor.backspace()
            textInput.expect("+1 234-56", "", "")
            editor.backspace()
            textInput.expect("+1 234-5", "", "")
            editor.backspace()
            textInput.expect("+1 234", "", "")
            editor.backspace()
            textInput.expect("+1 23", "", "")
            editor.backspace()
            textInput.expect("+1 2", "", "")
            editor.backspace()
            textInput.expect("+1", "", "")
            editor.backspace()
            textInput.expect("+", "", "")
            editor.backspace()
            textInput.expect("", "", "")
        }
    }

}
