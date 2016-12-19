//
//  BankCardHolderNameTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

final class BankCardHolderNameTextInputFormatter : TextInputFormatter {

    init(_ options: BankCardHolderNameTextInputOptions) {
        self.options = options
        self.deniedCharacters = CharacterSet(charactersIn: UnicodeScalar("A")...UnicodeScalar("Z"))
            .union(allowedNonLetterCharacters)
            .inverted
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        do {
            let adjustedReplacementStringView = try self.adjustedReplacementString(from: replacementString).unicodeScalars

            let originalStringView = originalString.unicodeScalars
            let editedRangeInStringView = editedRange.sameRange(in: originalStringView)

            let (resultingStringView, editedRangeInResultingStringView) = {
                originalStringView.replacingSubrangeAndReturningNewSubrange(editedRangeInStringView, with: adjustedReplacementStringView)
            }()

            try validatePunctuation(in: resultingStringView, afterEditing: editedRangeInResultingStringView)
            try validateLength(of: resultingStringView)

            let resultingString = String(resultingStringView)
            let resultingCursorIndex = editedRangeInResultingStringView.upperBound.samePosition(in: resultingString)!

            return .optimalValidationResult(
                forEditing: originalString,
                replacing: replacementString,
                at: editedRange,
                resulting: resultingString,
                withSelection: resultingCursorIndex..<resultingCursorIndex)
        }
        catch let error {
            precondition(error is ValidationError)

            return .rejected
        }
    }

    fileprivate let allowedNonLetterCharacters = CharacterSet(charactersIn: "-. ")

    fileprivate let deniedCharacters: CharacterSet

    fileprivate let options: BankCardHolderNameTextInputOptions

}

private extension BankCardHolderNameTextInputFormatter {

    enum ValidationError : Error {

        case invalidCharactersInReplacementString

        case invalidPunctuation

        case maxLengthExceeded
        
    }

    func adjustedReplacementString(from replacementString: String) throws -> String {
        let adjustedReplacementString = replacementString
            .folding(options: [.diacriticInsensitive, .widthInsensitive], locale: nil)
            .uppercased(with: nil)

        if adjustedReplacementString.rangeOfCharacter(from: deniedCharacters) != nil {
            throw ValidationError.invalidCharactersInReplacementString
        }

        return adjustedReplacementString
    }

    func validatePunctuation(
        in stringView: String.UnicodeScalarView,
        afterEditing editedRange: Range<String.UnicodeScalarIndex>) throws {

        var windowRange: Range<String.UnicodeScalarIndex> = {
            let lowerBound = editedRange.lowerBound == stringView.startIndex
                ? editedRange.lowerBound
                : stringView.index(before: editedRange.lowerBound)
            let upperBound = editedRange.upperBound == stringView.endIndex
                ? editedRange.upperBound
                : stringView.index(after: editedRange.upperBound)
            return lowerBound..<upperBound
        }()

        while let nonLetterCharacterIndex = stringView[windowRange].index(where: { allowedNonLetterCharacters.contains($0) }) {
            let nextCharacterIndex = stringView.index(after: nonLetterCharacterIndex)

            if nextCharacterIndex == windowRange.upperBound {
                break
            }

            if allowedNonLetterCharacters.contains(stringView[nextCharacterIndex]) {
                throw ValidationError.invalidPunctuation
            }

            windowRange = stringView.index(after: nextCharacterIndex) ..< windowRange.upperBound
        }
    }

    func validateLength(
        of stringView: String.UnicodeScalarView) throws {

        if stringView.count > options.maxLength {
            throw ValidationError.maxLengthExceeded
        }
    }

}
