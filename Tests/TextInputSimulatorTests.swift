//
//  TextInputSimulatorTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 05/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import XCTest
import TextInputKit

class TextInputSimulatorTests: XCTestCase {

    let sampleFormat: TextInputFormat<Int> = {
        enum FormatError : Error {
            case invalidValue
        }

        return TextInputFormats.plain
            .filter(by: CharacterSet.decimalDigits)
            .transformValue(
                direct: { text -> Int in
                    guard let value = Int(text) else { throw FormatError.invalidValue }
                    return value
            },
                reverse: { value -> String in
                    return value.description
            })
    }()

    var textInput: TextInputSimulator!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator()
    }

    func testThatDefaultStateIsCorrect() {
        textInput.expect(text: "", selectedRange: nil)
    }

    func testThatTextCanBeSet() {
        textInput.text = "abc"
        textInput.expect(text: "abc")
    }

    func testThatSelectedRangeIsNotNilOnlyWhenEditing() {
        textInput.expect(text: "", selectedRange: nil)

        textInput.edit { _ in
            textInput.expect(text: "", selectedRange: "".endIndex ..< "".endIndex)
        }

        textInput.expect(text: "", selectedRange: nil)
    }

    func testThatEditorInsertionWorks() {
        textInput.edit { editor in
            editor.insert("ab")
            textInput.expect("ab", "", "")

            editor.select(1..<1)
            editor.insert("d")
            textInput.expect("ad", "", "b")
        }

        textInput.expect(text: "adb")
    }

    func testThatEditorBackspaceWorks() {
        textInput.edit { editor in
            editor.insert("abcd")
            textInput.expect("abcd", "", "")

            editor.backspace()
            textInput.expect("abc", "", "")

            editor.select(2..<2)
            editor.backspace()
            textInput.expect("a", "", "c")

            editor.backspace()
            textInput.expect("", "", "c")
        }

        textInput.expect(text: "c")
    }

    func testThatValueAndTextAreResetAfterBinding() {
        let textInputBinding = sampleFormat.bind(to: textInput)

        XCTAssertEqual(textInputBinding.value, nil)
        textInput.expect(text: "")
    }

    func testThatChangingValueInBindingUpdatesText() {
        let textInputBinding = sampleFormat.bind(to: textInput)

        textInputBinding.value = 123
        textInput.expect(text: "123")
    }

    func testThatTextInputFormattingWorks() {
        let textInputBinding = sampleFormat.bind(to: textInput)
        // The following line is needed to suppress a compiler warning.
        // We don't need `textInputBinding` variable, but we need to control the lifecycle of a binding.
        _ = textInputBinding

        textInput.edit { editor in
            editor.insert("a")
            textInput.expect("", "", "")
        }

        textInput.edit { editor in
            editor.insert("1")
            textInput.expect("1", "", "")
        }
    }

    func testThatEditingTextUpdatesValueInBinding() {
        let textInputBinding = sampleFormat.bind(to: textInput)

        textInput.edit { editor in
            editor.insert("123")
        }

        XCTAssertEqual(textInputBinding.value, 123)

        textInput.edit { editor in
            editor.clear()
        }

        XCTAssertEqual(textInputBinding.value, nil)
    }

}
