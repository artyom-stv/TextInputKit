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
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        do {
            let adjustedReplacementString = try self.adjustedReplacementString(from: replacementString)

            let input = ValidationInput(
                stringView: originalString.unicodeScalars,
                selectedRange: originalSelectedRange.sameRange(in: originalString.unicodeScalars)!,
                replacementStringView: adjustedReplacementString.unicodeScalars,
                editedRange: editedRange.sameRange(in: originalString.unicodeScalars)!)

            var result: ValidationResult = {
                let (resultingStringView, editedRangeInResultingStringView) = {
                    input.stringView.replacingSubrangeAndReturningNewSubrange(input.editedRange, with: input.replacementStringView)
                }()
                return ValidationResult(
                    stringView: resultingStringView,
                    cursorIndex: editedRangeInResultingStringView.upperBound)
            }()

            result = filteringPunctuation(in: result)

            try validateLength(of: result.stringView)

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
        catch let error {
            assert(error is ValidationError)

            return .rejected
        }
    }

    fileprivate let options: BankCardHolderNameTextInputOptions

}

private extension BankCardHolderNameTextInputFormatter {

    enum ValidationError : Error {

        case invalidCharactersInReplacementString

        case maxLengthExceeded
        
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

    func adjustedReplacementString(from replacementString: String) throws -> String {
        let adjustedReplacementString = replacementString
            .folding(options: [.widthInsensitive], locale: nil)
            .uppercased(with: nil)

        if adjustedReplacementString.rangeOfCharacter(from: Utils.deniedCharacters) != nil {
            throw ValidationError.invalidCharactersInReplacementString
        }

        return adjustedReplacementString
    }

    func filteringPunctuation(
        in originalValidationResult: ValidationResult) -> ValidationResult {

        let (resultingStringView, resultingCursorIndex) = {
            Utils.stringViewAndIndexAfterFilteringPunctuation(
                in: originalValidationResult.stringView,
                withIndex: originalValidationResult.cursorIndex)
        }()

        return ValidationResult(stringView: resultingStringView, cursorIndex: resultingCursorIndex)
    }

    func validateLength(
        of stringView: String.UnicodeScalarView) throws {

        if stringView.count > options.maxLength {
            throw ValidationError.maxLengthExceeded
        }
    }

    private typealias Utils = BankCardHolderNameUtils

}
