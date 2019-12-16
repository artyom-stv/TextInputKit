//
//  BankCardExpiryDateTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

final class BankCardExpiryDateTextInputFormatter : TextInputFormatter {

    init(_ options: BankCardExpiryDateTextInputOptions) {
        self.options = options
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        do {
            let input = ValidationInput(
                stringView: originalString.unicodeScalars,
                selectedRange: originalSelectedRange.sameRange(in: originalString.unicodeScalars)!,
                replacementStringView: replacementString.unicodeScalars,
                editedRange: editedRange.sameRange(in: originalString.unicodeScalars)!)

            let adjustedInput = self.adjustedInput(for: input)

            let result: ValidationResult = {
                let (resultingStringView, editedRangeInResultingStringView) = {
                    adjustedInput.stringView.replacingSubrangeAndReturningNewSubrange(adjustedInput.editedRange, with: adjustedInput.replacementStringView)
                }()
                return ValidationResult(
                    stringView: resultingStringView,
                    cursorIndex: editedRangeInResultingStringView.upperBound)
            }()

            let slashIndex = self.slashIndex(in: result.stringView)

            try validateResult(result, slashIndex: slashIndex)

            let adjustedResult = self.adjustedResult(for: result, slashIndex: slashIndex)

            let resultingString = String(adjustedResult.stringView)
            let resultingCursorIndex = adjustedResult.cursorIndex.samePosition(in: resultingString)!

            return .optimalValidationResult(
                forEditing: originalString,
                replacing: replacementString,
                at: editedRange,
                withSelection: originalSelectedRange,
                resulting: resultingString,
                withSelection: resultingCursorIndex..<resultingCursorIndex)
        }
        catch let error {
            assert(error is ValidationError)

            return .rejected
        }
    }

    private let options: BankCardExpiryDateTextInputOptions

}

private extension BankCardExpiryDateTextInputFormatter {

    enum ValidationError : Error {

        case invalidCharacter

        case tooLongDigitsSequence

    }

    struct ValidationInput {
        let stringView: String.UnicodeScalarView
        let selectedRange: Range<String.UnicodeScalarIndex>
        let replacementStringView:String.UnicodeScalarView
        let editedRange: Range<String.UnicodeScalarIndex>
    }

    struct ValidationResult {
        let stringView: String.UnicodeScalarView
        let cursorIndex: String.UnicodeScalarIndex
    }

    func adjustedInput(for input: ValidationInput) -> ValidationInput {
        var adjustedEditedRange = input.editedRange

        let wasPressedBackspaceOrDeleteWithEmptySelection = input.selectedRange.isEmpty && !input.editedRange.isEmpty
        if wasPressedBackspaceOrDeleteWithEmptySelection {
            assert(input.stringView.distance(from: input.editedRange.lowerBound, to: input.editedRange.upperBound) == 1,
                   "Only when a user presses 'backspace' or 'delete' key, the edited range can be non-empty while the selected range is empty.")

            let isDeletingSlashCharacter = input.stringView[input.editedRange.lowerBound] == UnicodeScalar("/")
            if isDeletingSlashCharacter {
                let wasPressedBackspace = input.selectedRange.lowerBound == input.editedRange.upperBound
                if wasPressedBackspace {
                    // Backspace
                    let canShiftEditedRange = input.editedRange.lowerBound != input.stringView.startIndex
                    if canShiftEditedRange {
                        let lowerBound = input.stringView.index(before: input.editedRange.lowerBound)
                        let upperBound = (input.editedRange.upperBound == input.stringView.endIndex) ? input.editedRange.upperBound : input.editedRange.lowerBound
                        adjustedEditedRange = lowerBound..<upperBound
                    }
                }
                else {
                    // Delete
                    let canShiftEditedRange = input.editedRange.upperBound != input.stringView.endIndex
                    if canShiftEditedRange {
                        adjustedEditedRange = input.editedRange.upperBound ..< input.stringView.index(after: input.editedRange.upperBound)
                    }
                }
            }
        }

        return ValidationInput(
            stringView: input.stringView,
            selectedRange: input.selectedRange,
            replacementStringView: input.replacementStringView,
            editedRange: adjustedEditedRange)
    }

    func adjustedResult(
        for result: ValidationResult,
        slashIndex: String.UnicodeScalarIndex?
        ) -> ValidationResult {

        if (slashIndex == nil)
            && (result.cursorIndex == result.stringView.endIndex)
            && (result.stringView.count == type(of: self).maxAllowedDigitsSequenceLength) {

            var adjustedStringView = result.stringView
            adjustedStringView.append(UnicodeScalar("/"))

            return ValidationResult(
                stringView: adjustedStringView,
                cursorIndex: adjustedStringView.endIndex)
        }

        return result
    }

    func slashIndex(in stringView: String.UnicodeScalarView) -> String.UnicodeScalarIndex? {
        return stringView.firstIndex(where: { StringUtils.slashCharacters.contains($0) })
    }

    func validateResult(_ result: ValidationResult, slashIndex: String.UnicodeScalarIndex?) throws {
        if let slashIndex = slashIndex {
            try validateDigitsSequence(result.stringView[result.stringView.startIndex..<slashIndex])
            try validateDigitsSequence(result.stringView[result.stringView.index(after: slashIndex)..<result.stringView.endIndex])
        }
        else {
            try validateDigitsSequence(result.stringView)
        }
    }

    private static let maxAllowedDigitsSequenceLength = 2

    private func validateDigitsSequence<StringView>(_ stringView: StringView) throws
        where StringView: Collection, StringView.Element == UnicodeScalar
    {
        if stringView.contains(where: { !CharacterSet.decimalDigits.contains($0) }) {
            throw ValidationError.invalidCharacter
        }

        if stringView.count > type(of: self).maxAllowedDigitsSequenceLength {
            throw ValidationError.tooLongDigitsSequence
        }
    }

}
