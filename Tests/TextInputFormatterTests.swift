//
//  TextInputFormatterTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 28/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

private func sampleString(characterSet: CharacterSet, unicodeScalarsRange: CountableClosedRange<UInt32>) -> String {
    var string = ""
    for i in unicodeScalarsRange {
        if let unicodeScalar = UnicodeScalar(i), characterSet.contains(unicodeScalar) {
            string.append(Character(unicodeScalar))
        }
    }
    return string
}

class TextInputFormatterTests : XCTestCase {

    // TODO: Implement.
//    func testThatBaseClassIsAbstract() {
//        let formatter = TextInputFormatter()
//        expectFatalError {
//            let originalString = ""
//            let replacementString = ""
//            let editedRange = originalString.startIndex..<originalString.endIndex
//            let originalSelectedRange = originalString.startIndex..<originalString.endIndex
//
//            _ = formatter.validate(
//                editing: originalString,
//                withSelection: originalSelectedRange,
//                replacing: replacementString,
//                at: editedRange)
//        }
//    }

}

// MARK: Test TextInputFormatterType+Plain
extension TextInputFormatterTests {

    func testThatPlainFormatterAcceptsAnyInput() {
        let formatter = TextInputFormatter.plain

        func test(_ replacementString: String) {
            let originalString = ""
            let editedRange = originalString.startIndex..<originalString.endIndex
            let originalSelectedRange = originalString.startIndex..<originalString.endIndex

            let validationResult = formatter.validate(
                editing: originalString,
                withSelection: originalSelectedRange,
                replacing: replacementString,
                at: editedRange)

            let isAccepted: Bool
            if case .accepted = validationResult {
                isAccepted = true
            } else {
                isAccepted = false
            }

            XCTAssertTrue(isAccepted)
        }

        let characterSet = CharacterSet.alphanumerics
            .union(CharacterSet.punctuationCharacters)
            .union(CharacterSet.symbols)
        for stringNumber in 0x00...0xFF {
            let string = sampleString(
                characterSet: characterSet,
                unicodeScalarsRange: UInt32(stringNumber * 0x100 + 0x00)...UInt32(stringNumber * 0x100 + 0xFF)
            )

            test(string)
        }
    }

}

// MARK: Test TextInputFormatterType+Filter
extension TextInputFormatterTests {

    func testThatFilterWorksWithPlainFormatter() {
        var expectedFilterString = ""
        var filterResult = false
        let formatter = TextInputFormatter.plain.filter { string -> Bool in
            XCTAssertEqual(string, expectedFilterString)
            return filterResult
        }

        func test(_ replacementString: String) {
            let originalString = ""
            let editedRange = originalString.startIndex..<originalString.endIndex
            let originalSelectedRange = originalString.startIndex..<originalString.endIndex

            let editedString = originalString.replacingCharacters(in: editedRange, with: replacementString)

            expectedFilterString = editedString

            for isFilterPassing in [false, true] {
                filterResult = isFilterPassing

                let expectedValidationResult: TextInputValidationResult = isFilterPassing
                    ? .accepted
                    : .rejected

                let validationResult = formatter.validate(
                    editing: originalString,
                    withSelection: originalSelectedRange,
                    replacing: replacementString,
                    at: editedRange)

                XCTAssertEqual(validationResult, expectedValidationResult)
            }
        }

        test("Test")
    }
    
}

// MARK: Test TextInputFormatterType+Map
extension TextInputFormatterTests {

    func testThatMapWorksWithPlainFormatter() {
        var expectedMapString = ""
        var expectedMapSelectedRange = "".endIndex..<"".endIndex
        var mapResult = ("", "".endIndex..<"".endIndex)
        let formatter = TextInputFormatter.plain.map { (string, selectedRange) in
            XCTAssertEqual(string, expectedMapString)
            XCTAssertEqual(selectedRange, expectedMapSelectedRange)
            return mapResult
        }

        func test(_ replacementString: String, _ mappedEditedString: String) {
            let originalString = ""
            let editedRange = originalString.startIndex..<originalString.endIndex
            let originalSelectedRange = originalString.startIndex..<originalString.endIndex

            let editedString = originalString.replacingCharacters(in: editedRange, with: replacementString)
            let resultingSelectedRange = editedString.endIndex..<editedString.endIndex

            expectedMapString = editedString
            expectedMapSelectedRange = resultingSelectedRange

            for isMappingIdentically in [false, true] {
                let expectedValidationResult: TextInputValidationResult
                if isMappingIdentically {
                    mapResult = (editedString, resultingSelectedRange)
                    expectedValidationResult = .accepted
                }
                else {
                    let mappedSelectedRange = mappedEditedString.startIndex..<mappedEditedString.endIndex
                    mapResult = (mappedEditedString, mappedSelectedRange)
                    expectedValidationResult = .changed(mappedEditedString, selectedRange: mappedSelectedRange)
                }

                let validationResult = formatter.validate(
                    editing: originalString,
                    withSelection: originalSelectedRange,
                    replacing: replacementString,
                    at: editedRange)

                XCTAssertEqual(validationResult, expectedValidationResult)
            }
        }
        
        test("Abc", "Defgh")
    }
    
}
