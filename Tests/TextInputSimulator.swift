//
//  TextInputSimulator.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 02/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
import Nimble
@testable import TextInputKit

class TextInputSimulator {

    weak var delegate: TextInputSimulatorDelegate?

    var text: String

    fileprivate(set) var selectedRange: Range<String.Index>?

    init() {
        self.text = ""
        self.selectedRange = nil
    }

}

extension TextInputSimulator {

    class Editor {

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

            textInput.delegate?.editingChanged()
        }

        func select(_ range: Range<String.Index>) {
            guard range.lowerBound >= text.startIndex && range.upperBound <= text.endIndex else {
                Swift.fatalError("Proposed selected range doesn't fit text.")
            }

            selectedRange = range
        }

        fileprivate var text: String {
            get {
                return textInput.text
            }
            set(newText) {
                textInput.text = newText
            }
        }

        fileprivate var selectedRange: Range<String.Index> {
            get {
                return textInput.selectedRange!
            }
            set(newSelectedRange) {
                textInput.selectedRange = newSelectedRange
            }
        }

        fileprivate init(_ textInput: TextInputSimulator) {
            self.textInput = textInput
        }

        private let textInput: TextInputSimulator

        private func replace(_ replacementString: String, _ replacementRange: Range<String.Index>) {
            let validationResult: TextInputValidationResult = textInput.delegate?.validate(
                editing: text,
                withSelection: selectedRange,
                replacing: replacementString,
                at: replacementRange) ?? .accepted

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

                textInput.delegate?.editingChanged()

            case .changed(let newResultingText, let newResultingSelectedRange):
                text = newResultingText
                selectedRange = newResultingSelectedRange

                textInput.delegate?.editingChanged()

            case .rejected:
                break
            }
        }

    }

    func edit(_ actions: (Editor) -> ()) {
        selectedRange = text.endIndex..<text.endIndex
        delegate?.editingDidBegin()
        actions(Editor(self))
        delegate?.editingDidEnd()
        selectedRange = nil
    }

}

extension TextInputSimulator.Editor {

    func select(_ range: Range<Int>) {
        guard
            let startIndex = text.index(text.startIndex, offsetBy: range.lowerBound, limitedBy: text.endIndex),
            let endIndex = text.index(startIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: text.endIndex)
            else {
                Swift.fatalError("The provided `range` is out of the `text` indices bounds.")
        }
        select(startIndex..<endIndex)
    }

    func selectAll() {
        select(text.startIndex..<text.endIndex)
    }

}

extension TextInputSimulator {

    func expect(
        text expectedText: String,
        selectedRange expectedSelectedRange: Range<String.Index>? = nil,
        file: FileString = #file,
        line: UInt = #line) {

        Nimble.expect(self.text, file: file, line: line)
            .to(equal(expectedText),
                description: "Invalid text in a `TextInputSimulator`.")

        let selectedIntRange: Range<Int>?
        if let selectedRange = selectedRange {
            selectedIntRange = text.distance(from: text.startIndex, to: selectedRange.lowerBound) ..< text.distance(from: text.startIndex, to: selectedRange.upperBound)
        }
        else {
            selectedIntRange = nil
        }

        let expectedSelectedIntRange: Range<Int>?
        if let expectedSelectedRange = expectedSelectedRange {
            expectedSelectedIntRange = expectedText.distance(from: expectedText.startIndex, to: expectedSelectedRange.lowerBound) ..< expectedText.distance(from: expectedText.startIndex, to: expectedSelectedRange.upperBound)
        }
        else {
            expectedSelectedIntRange = nil
        }

        if let expectedSelectedIntRange = expectedSelectedIntRange {
            Nimble.expect(selectedIntRange, file: file, line: line)
                .to(equal(expectedSelectedIntRange),
                    description: "Invalid selected range in a `TextInputSimulator`.")
        }
        else {
            Nimble.expect(selectedIntRange, file: file, line: line)
                .to(beNil(),
                    description: "Invalid selected range in a `TextInputSimulator`.")
        }
    }

    func expect(
        _ textBeforeSelection: String,
        _ selectedText: String,
        _ textAfterSelection: String,
        file: FileString = #file,
        line: UInt = #line) {

        let text = "\(textBeforeSelection)\(selectedText)\(textAfterSelection)"
        let selectionLowerBound = text.index(
            text.startIndex,
            offsetBy: textBeforeSelection.characters.count)
        let selectionUpperBound = text.index(
            text.startIndex,
            offsetBy: textBeforeSelection.characters.count + selectedText.characters.count)

        expect(
            text: text,
            selectedRange: selectionLowerBound..<selectionUpperBound,
            file: file,
            line: line)
    }

}
