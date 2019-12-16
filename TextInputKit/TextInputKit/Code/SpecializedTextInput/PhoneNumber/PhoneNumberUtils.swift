//
//  PhoneNumberUtils.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 11/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation

struct PhoneNumberUtils {

    private init() {}

}

extension PhoneNumberUtils {

    struct CursorPositionInvariant {

        let numberOfDigitsAfterCursor: Int

    }

    static func cursorPositionInvariant(
        from cursorIndex: String.Index,
        in string: String
        ) -> CursorPositionInvariant {

        let stringView = string.unicodeScalars
        let cursorIndex = cursorIndex.samePosition(in: stringView)!

        let numberOfDigitsAfterCursor = stringView.suffix(from: cursorIndex).reduce(0) { (result, unicodeScalar) in
            return StringUtils.isDigit(unicodeScalar) ? result + 1 : result
        }
        return CursorPositionInvariant(numberOfDigitsAfterCursor: numberOfDigitsAfterCursor)
    }

    static func cursorIndex(
        from invariant: CursorPositionInvariant,
        in string: String
        ) -> String.Index {

        let stringView = string.unicodeScalars

        var cursorIndex = stringView.endIndex
        var numberOfDigits = 0
        while cursorIndex > stringView.startIndex {
            if numberOfDigits == invariant.numberOfDigitsAfterCursor {
                break
            }

            cursorIndex = stringView.index(before: cursorIndex)

            if StringUtils.isDigit(stringView[cursorIndex]) {
                numberOfDigits += 1
            }
        }

        return cursorIndex.samePosition(in: string)!
    }

}

extension PhoneNumberUtils {

    static func adjustedEditedRange(
        forEditing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> Range<String.Index> {

        let wasPressedBackspaceOrDeleteWithEmptySelection = originalSelectedRange.isEmpty && !editedRange.isEmpty
        if wasPressedBackspaceOrDeleteWithEmptySelection {
            assert(originalString.distance(from: editedRange.lowerBound, to: editedRange.upperBound) == 1,
                   "Edited range can be non-empty while selected range is empty only when user presses 'backspace' or 'delete' key.")

            let originalStringView = originalString.unicodeScalars
            let wasPressedBackspace = (originalSelectedRange.lowerBound == editedRange.upperBound)
            if wasPressedBackspace {
                // Backspace
                var adjustedLowerBound = editedRange.lowerBound.samePosition(in: originalStringView)!
                while adjustedLowerBound != originalStringView.startIndex {
                    if StringUtils.isDigit(originalStringView[adjustedLowerBound]) {
                        break
                    }
                    adjustedLowerBound = originalStringView.index(before: adjustedLowerBound)
                }
                return adjustedLowerBound.samePosition(in: originalString)! ..< editedRange.upperBound
            }
            else {
                // Delete
                var adjustedUpperBound = editedRange.upperBound.samePosition(in: originalStringView)!
                while adjustedUpperBound != originalStringView.endIndex {
                    if StringUtils.isDigit(originalStringView[adjustedUpperBound]) {
                        break
                    }
                    adjustedUpperBound = originalStringView.index(after: adjustedUpperBound)
                }
                return editedRange.lowerBound ..< adjustedUpperBound.samePosition(in: originalString)!
            }
        }

        return editedRange
    }

    static func adjustedString(
        afterEditing originalString: String,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> String {

        var editedString = originalString.replacingCharacters(in: editedRange, with: replacementString)

        if let firstUnicodeScalar = editedString.unicodeScalars.first, !StringUtils.isPlus(firstUnicodeScalar) {
            editedString.insert("+", at: editedString.startIndex)
        }
        
        return editedString
    }
    
}

extension PhoneNumberUtils {

    static func isValidPhoneNumber(_ phoneNumberString: String) -> Bool {
        return phoneNumberString.rangeOfCharacter(from: deniedCharacters) == nil
    }

    private static let deniedCharacters: CharacterSet = {
        var allowedCharacters = CharacterSet.decimalDigits
        allowedCharacters.formUnion(StringUtils.plusCharacters)
        allowedCharacters.formUnion(StringUtils.spaceCharacters)
        allowedCharacters.formUnion(StringUtils.dashCharacters)
        allowedCharacters.formUnion(StringUtils.paranthesisCharacters)
        allowedCharacters.formUnion(StringUtils.pointCharacters)
        return allowedCharacters.inverted
    }()

}
