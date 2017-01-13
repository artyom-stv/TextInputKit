//
//  PhoneNumberTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 27/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import PhoneNumberKit

final class PhoneNumberTextInputFormatter : TextInputFormatter {

    init(_ options: PhoneNumberTextInputOptions, _ cachedPhoneNumberKit: CachedPhoneNumberKit) {
        self.options = options
        self.cachedPhoneNumberKit = cachedPhoneNumberKit
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        do {
            let adjustedEditedRange = Utils.adjustedEditedRange(
                forEditing: originalString,
                withSelection: originalSelectedRange,
                replacing: replacementString,
                at: editedRange)

            let cursorPositionInvariant = Utils.cursorPositionInvariant(
                from: adjustedEditedRange.upperBound,
                in: originalString)

            let editedString = Utils.adjustedString(
                afterEditing: originalString,
                replacing: replacementString,
                at: adjustedEditedRange)

            let resultingString = try formattedString(editedString)
            let resultingCursorIndex = Utils.cursorIndex(from: cursorPositionInvariant, in: resultingString)

            return .optimalValidationResult(
                forEditing: originalString,
                replacing: replacementString,
                at: editedRange,
                withSelection: originalSelectedRange,
                resulting: resultingString,
                withSelection: resultingCursorIndex..<resultingCursorIndex)
        } catch {
            return .rejected
        }
    }

    fileprivate typealias Utils = PhoneNumberUtils

    fileprivate lazy var partialFormatter: PartialFormatter = {
        return PartialFormatter(phoneNumberKit: self.cachedPhoneNumberKit.instance)
    }()

    private let options: PhoneNumberTextInputOptions

    private let cachedPhoneNumberKit: CachedPhoneNumberKit

}

private extension PhoneNumberTextInputFormatter {

    enum ValidationError : Error {

        case invalidPhoneNumber

    }

    func formattedString(_ string: String) throws -> String {
        let formattedString = partialFormatter.formatPartial(string)

        if !Utils.isValidPhoneNumber(formattedString) {
            throw ValidationError.invalidPhoneNumber
        }

        return formattedString
    }

}
