//
//  BankCardNumberTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

final class BankCardNumberTextInputFormatter : TextInputFormatter {

    init(_ options: BankCardNumberTextInputOptions) {
        self.options = options
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        let originalString = originalString.unicodeScalars
        let originalSelectedRange = originalSelectedRange.sameRange(in: originalString)
        let replacementString = replacementString.unicodeScalars
        let editedRange = editedRange.sameRange(in: originalString)

        guard let (originalDigitsString, originalDigitsEditedRange) = Utils.cardNumberDigitsStringWithRange(from: (originalString, editedRange))
            else {
                fatalError("Invalid characters in a string provided to the bank card number formatter. Possible reason: text was modified directly in the text field binded to the bank card number formatter.")
        }

        guard let replacementDigitsString = Utils.cardNumberDigitsString(from: replacementString) else {
            // `replacementString` has invalid characters.
            return .rejected
        }

        let adjustedDigitsEditedRange = self.adjustedDigitsEditedRange(
            forOriginalString: originalString,
            originalSelectedRange: originalSelectedRange,
            editedRange: editedRange,
            originalDigitsString: originalDigitsString,
            originalDigitsEditedRange: originalDigitsEditedRange)

        let (resultingDigitsString, editedRangeInResultingDigitsString) = {
            originalDigitsString.replacingSubrangeAndReturningNewSubrange(adjustedDigitsEditedRange, with: replacementDigitsString)
        }()

        let resultingDigitsCursorIndex = editedRangeInResultingDigitsString.upperBound

        let resultingDigitsStringLength = resultingDigitsString.count
        let iinRange = Utils.iinRange(fromDigitsString: String(resultingDigitsString), withLength: resultingDigitsStringLength)
        let iinRangeInfo = Utils.info(forIinRange: iinRange)
        let sortedSpacesPositions = Utils.sortedSpacesPositions(for: iinRangeInfo?.cardBrand)

        let (cardNumber, resultingCursorIndex) = Utils.cardNumberWithIndex(
            fromDigitsString: resultingDigitsString,
            withLength: resultingDigitsStringLength,
            index: resultingDigitsCursorIndex,
            sortedSpacesPositions: sortedSpacesPositions)

        return {
            let cardNumber = String(cardNumber)
            let resultingCursorIndex = resultingCursorIndex.samePosition(in: cardNumber)!
            return .changed(cardNumber, selectedRange: resultingCursorIndex..<resultingCursorIndex)
            }()
    }

    private typealias Utils = BankCardNumberUtils

    private let options: BankCardNumberTextInputOptions

    /// Adjusts edited range in `originalDigitsString` taking into account the case when user presses 'backspace' or 'delete' key with empty selection.
    private func adjustedDigitsEditedRange(
        forOriginalString originalString: String.UnicodeScalarView,
        originalSelectedRange: Range<String.UnicodeScalarIndex>,
        editedRange: Range<String.UnicodeScalarIndex>,
        originalDigitsString: String.UnicodeScalarView,
        originalDigitsEditedRange: Range<String.UnicodeScalarIndex>
        ) -> Range<String.UnicodeScalarIndex> {

        if originalSelectedRange.isEmpty && !editedRange.isEmpty {
            // User pressed 'backspace' or 'delete' key with empty selection.
            precondition(originalString.distance(from: editedRange.lowerBound, to: editedRange.upperBound) == 1,
                         "Edited range can be non-empty while selected range is empty only when user presses 'backspace' or 'delete' key.")

            if originalString[editedRange.lowerBound] == " " {
                // User pressed 1) 'backspace' key after 'space' character; or 2) 'delete' key before 'space' character.
                if originalSelectedRange.lowerBound == editedRange.upperBound {
                    // Backspace
                    if originalDigitsEditedRange.lowerBound != originalDigitsString.startIndex {
                        return originalDigitsString.index(before: originalDigitsEditedRange.lowerBound) ..< originalDigitsEditedRange.upperBound
                    }
                }
                else {
                    // Delete
                    if originalDigitsEditedRange.upperBound != originalDigitsString.endIndex {
                        return originalDigitsEditedRange.lowerBound ..< originalDigitsString.index(after: originalDigitsEditedRange.upperBound)
                    }
                }
            }
        }

        return originalDigitsEditedRange
    }

}
