//
//  BankCardNumberTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

final class BankCardNumberTextInputFormatter : TextInputFormatter {

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
            selectedRange: originalSelectedRange.sameRange(in: originalString.unicodeScalars),
            replacementStringView: replacementString.unicodeScalars,
            editedRange: editedRange.sameRange(in: originalString.unicodeScalars))

        guard let digitsInput = self.digitsInput(from: originalInput) else {
            // `replacementString` has invalid characters.
            return .rejected
        }

        let digitsResult = self.digitsResult(from: digitsInput)
        let result = self.cardNumberResult(from: digitsResult)

        return {
            let cardNumber = String(result.stringView)
            let cursorIndex = result.cursorIndex.samePosition(in: cardNumber)!
            return .changed(cardNumber, selectedRange: cursorIndex..<cursorIndex)
            }()
    }

    private let options: BankCardNumberTextInputOptions

}

private extension BankCardNumberTextInputFormatter {

    struct OriginalValidationInput {
        let stringView: String.UnicodeScalarView
        let selectedRange: Range<String.UnicodeScalarIndex>
        let replacementStringView:String.UnicodeScalarView
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

    func digitsInput(from originalInput: OriginalValidationInput) -> DigitsValidationInput? {
        guard let (digitsStringView, digitsEditedRange) = Utils.cardNumberDigitsStringViewAndRange(from: originalInput.stringView, range: originalInput.editedRange)
            else {
                fatalError("Invalid characters in a string provided to the bank card number formatter. Possible reason: text was modified directly in the text field binded to the bank card number formatter.")
        }

        guard let digitsReplacementStringView = Utils.cardNumberDigitsStringView(from: originalInput.replacementStringView) else {
            // `originalInput.replacementStringView` has invalid characters.
            return nil
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

    func cardNumberResult(from digitsResult: DigitsValidationResult) -> CardNumberValidationResult {
        // Length of ASCII string is similar in `characters` and in `unicodeScalars`.
        let resultingDigitsStringLength = digitsResult.stringView.count

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

    /// Adjusts edited range in `originalDigitsString` taking into account the case when user presses 'backspace' or 'delete' key with empty selection.
    private func adjustedDigitsEditedRange(
        forOriginalInput originalInput: OriginalValidationInput,
        digitsStringView: String.UnicodeScalarView,
        digitsEditedRange: Range<String.UnicodeScalarIndex>
        ) -> Range<String.UnicodeScalarIndex> {

        if originalInput.selectedRange.isEmpty && !originalInput.editedRange.isEmpty {
            // User pressed 'backspace' or 'delete' key with empty selection.
            precondition(originalInput.stringView.distance(from: originalInput.editedRange.lowerBound, to: originalInput.editedRange.upperBound) == 1,
                         "Edited range can be non-empty while selected range is empty only when user presses 'backspace' or 'delete' key.")

            if originalInput.stringView[originalInput.editedRange.lowerBound] == " " {
                // User pressed 1) 'backspace' key after 'space' character; or 2) 'delete' key before 'space' character.
                if originalInput.selectedRange.lowerBound == originalInput.editedRange.upperBound {
                    // Backspace
                    if digitsEditedRange.lowerBound != digitsStringView.startIndex {
                        return digitsStringView.index(before: digitsEditedRange.lowerBound) ..< digitsEditedRange.upperBound
                    }
                }
                else {
                    // Delete
                    if digitsEditedRange.upperBound != digitsStringView.endIndex {
                        return digitsEditedRange.lowerBound ..< digitsStringView.index(after: digitsEditedRange.upperBound)
                    }
                }
            }
        }

        return digitsEditedRange
    }

}
