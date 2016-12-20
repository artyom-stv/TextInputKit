//
//  TextInputSimulator.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 02/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

class TextInputSimulator {

    let formatter: TextInputFormatter

    private(set) var text: String

    private(set) var selectedRange: Range<String.Index>

    init(_ formatter: TextInputFormatter) {
        self.formatter = formatter
        self.text = ""
        self.selectedRange = text.endIndex..<text.endIndex
    }

    func insert(_ insertionString: String) {
        replace(insertionString, selectedRange)
    }

    func backspace() {
        if selectedRange.isEmpty {
            if selectedRange.lowerBound != text.startIndex {
                let replacementRange = text.index(before: selectedRange.lowerBound) ..< selectedRange.lowerBound
                replace("", replacementRange)
            }
        }
        else {
            replace("", selectedRange)
        }
    }

    func clear() {
        text = ""
        selectedRange = text.endIndex..<text.endIndex
    }

    func select(_ range: Range<String.Index>) {
        guard range.lowerBound >= text.startIndex && range.upperBound <= text.endIndex else {
            Swift.fatalError("Proposed selected range doesn't fit text.")
        }

        selectedRange = range
    }

    private func replace(_ replacementString: String, _ replacementRange: Range<String.Index>) {
        let validationResult = formatter.validate(
            editing: text,
            withSelection: selectedRange,
            replacing: replacementString,
            at: replacementRange)

        switch validationResult {
        case .accepted:
            let resultingText = text.replacingCharacters(in: replacementRange, with: replacementString)

            let replacementLowerBoundInResultingText = (replacementRange.lowerBound == text.startIndex)
                ? resultingText.startIndex
                : resultingText.index(after: text.index(before: replacementRange.lowerBound))

            let resultingSelectedRange: Range<String.Index> = {
                let index = resultingText.index(replacementLowerBoundInResultingText, offsetBy: replacementString.characters.count)
                return index..<index
            }()

            text = resultingText
            selectedRange = resultingSelectedRange

        case .changed(let newResultingText, let newResultingSelectedRange):
            text = newResultingText
            selectedRange = newResultingSelectedRange

        case .rejected:
            break
        }
    }
    
}

extension TextInputSimulator {

    func select(_ range: Range<Int>) {
        let startIndex = text.index(text.startIndex, offsetBy: range.lowerBound)
        let endIndex = text.index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        select(startIndex..<endIndex)
    }

    func selectAll() {
        select(text.startIndex..<text.endIndex)
    }

}

extension TextInputSimulator {

    func expect(text: String, selectedRange: Range<String.Index>) {
        XCTAssertEqual(self.text, text)
        XCTAssertEqual(self.selectedRange, selectedRange)
    }

    func expect(_ textBeforeSelection: String, _ selectedText: String, _ textAfterSelection: String) {
        let text = "\(textBeforeSelection)\(selectedText)\(textAfterSelection)"
        let selectionLowerBound = text.index(
            text.startIndex,
            offsetBy: textBeforeSelection.characters.count)
        let selectionUpperBound = text.index(
            text.startIndex,
            offsetBy: textBeforeSelection.characters.count + selectedText.characters.count)

        expect(text: text, selectedRange: selectionLowerBound..<selectionUpperBound)
    }

}
