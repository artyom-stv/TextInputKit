//
//  BankCardNumberTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

final class BankCardNumberTextInputFormatter: TextInputFormatter {

    init(_ options: BankCardNumberTextInputOptions) {
        self.options = options
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        let originalInput = OriginalValidationInput(
            stringView: originalString.unicodeScalars,
            selectedRange: originalSelectedRange.sameRange(in: originalString.unicodeScalars)!,
            replacementStringView: replacementString.unicodeScalars,
            editedRange: editedRange.sameRange(in: originalString.unicodeScalars)!)

        do {
            let digitsInput = try self.digitsInput(from: originalInput)

            let digitsResult = self.digitsResult(from: digitsInput)

            let result = try self.cardNumberResult(from: digitsResult)

            let resultingString = String(result.stringView)
            let resultingCursorIndex = result.cursorIndex.samePosition(in: resultingString)!

            return .optimalValidationResult(
                forEditing: originalString,
                replacing: replacementString,
                at: editedRange,
                withSelection: originalSelectedRange,
                resulting: resultingString,
                withSelection: resultingCursorIndex..<resultingCursorIndex)
        }
        catch {
            return .rejected
        }
    }

    fileprivate let options: BankCardNumberTextInputOptions

}

private extension BankCardNumberTextInputFormatter {

    enum ValidationError : Error {

        case invalidCharactersInReplacementString

        case maxLengthExceeded

    }

    struct OriginalValidationInput {
        let stringView: String.UnicodeScalarView
        let selectedRange: Range<String.UnicodeScalarIndex>
        let replacementStringView: String.UnicodeScalarView
        let editedRange: Range<String.UnicodeScalarIndex>
    }

    struct DigitsValidationInput {
        let stringView: String.UnicodeScalarView
        let replacementStringView:String.UnicodeScalarView
        let editedRange: Range<String.UnicodeScalarIndex>
    }

    struct DigitsValidationResult {
        let stringView: String.UnicodeScalarView
        let cursorIndex: String.UnicodeScalarIndex
    }

    struct CardNumberValidationResult {
        let stringView: String.UnicodeScalarView
        let cursorIndex: String.UnicodeScalarIndex
    }

    func digitsInput(from originalInput: OriginalValidationInput) throws -> DigitsValidationInput {
        guard let (digitsStringView, digitsEditedRange) = Utils.cardNumberDigitsStringViewAndRange(from: originalInput.stringView, range: originalInput.editedRange)
            else {
                fatalError("Invalid characters in a string provided to the bank card number formatter. Possible reason: text was modified directly in the text field binded to the bank card number formatter.")
        }

        guard let digitsReplacementStringView = Utils.cardNumberDigitsStringView(from: originalInput.replacementStringView) else {
            throw ValidationError.invalidCharactersInReplacementString
        }

        let adjustedDigitsEditedRange = self.adjustedDigitsEditedRange(
            forOriginalInput: originalInput,
            digitsStringView: digitsStringView,
            digitsEditedRange: digitsEditedRange)

        return DigitsValidationInput(
            stringView: digitsStringView,
            replacementStringView: digitsReplacementStringView,
            editedRange: adjustedDigitsEditedRange)
    }

    func digitsResult(from digitsInput: DigitsValidationInput) -> DigitsValidationResult {
        let (resultingDigitsStringView, editedRangeInResultingDigitsStringView) = {
            digitsInput.stringView.replacingSubrangeAndReturningNewSubrange(digitsInput.editedRange, with: digitsInput.replacementStringView)
        }()

        return DigitsValidationResult(
            stringView: resultingDigitsStringView,
            cursorIndex: editedRangeInResultingDigitsStringView.upperBound)
    }

    func cardNumberResult(from digitsResult: DigitsValidationResult) throws -> CardNumberValidationResult {
        // Length of ASCII string is similar in `characters` and in `unicodeScalars`.
        let resultingDigitsStringLength = digitsResult.stringView.count

        if resultingDigitsStringLength > options.maxLength {
            throw ValidationError.maxLengthExceeded
        }

        let iinRange = Utils.iinRange(
            fromDigitsString: String(digitsResult.stringView),
            withLength: resultingDigitsStringLength)
        let iinRangeInfo = Utils.info(forIinRange: iinRange)
        let sortedSpacesPositions = Utils.sortedSpacesPositions(for: iinRangeInfo?.cardBrand)

        let (cardNumberStringView, cardNumberCursorIndex) = Utils.cardNumberStringViewAndIndex(
            fromDigits: digitsResult.stringView,
            withLength: resultingDigitsStringLength,
            index: digitsResult.cursorIndex,
            sortedSpacesPositions: sortedSpacesPositions)

        return CardNumberValidationResult(
            stringView: cardNumberStringView,
            cursorIndex: cardNumberCursorIndex)
    }

    private typealias Utils = BankCardNumberUtils

    /// Adjusts the edited range in `originalDigitsString`. The edited range can be extended if the user
    /// presses 'backspace' or 'delete' key while having an empty selection.
    private func adjustedDigitsEditedRange(
        forOriginalInput originalInput: OriginalValidationInput,
        digitsStringView: String.UnicodeScalarView,
        digitsEditedRange: Range<String.UnicodeScalarIndex>
        ) -> Range<String.UnicodeScalarIndex> {

        let wasPressedBackspaceOrDeleteWithEmptySelection = originalInput.selectedRange.isEmpty && !originalInput.editedRange.isEmpty
        if wasPressedBackspaceOrDeleteWithEmptySelection {
            assert(originalInput.stringView.distance(from: originalInput.editedRange.lowerBound, to: originalInput.editedRange.upperBound) == 1,
                   "Only when a user presses 'backspace' or 'delete' key, the edited range can be non-empty while the selected range is empty.")

            let isDeletingSpaceCharacter = digitsEditedRange.isEmpty
            if isDeletingSpaceCharacter {
                assert(originalInput.stringView[originalInput.editedRange.lowerBound] == " ",
                       "When user pressed 'Backspace' or 'Delete', edited range in digits string can be empty only if edited character in original string is a 'Space' character.")

                let wasPressedBackspace = originalInput.selectedRange.lowerBound == originalInput.editedRange.upperBound
                if wasPressedBackspace {
                    // Backspace
                    let canExpandEditedRange = digitsEditedRange.lowerBound != digitsStringView.startIndex
                    if canExpandEditedRange {
                        return digitsStringView.index(before: digitsEditedRange.lowerBound) ..< digitsEditedRange.upperBound
                    }
                }
                else {
                    // Delete
                    let canExpandEditedRange = digitsEditedRange.upperBound != digitsStringView.endIndex
                    if canExpandEditedRange {
                        return digitsEditedRange.lowerBound ..< digitsStringView.index(after: digitsEditedRange.upperBound)
                    }
                }
            }
        }

        return digitsEditedRange
    }

}
