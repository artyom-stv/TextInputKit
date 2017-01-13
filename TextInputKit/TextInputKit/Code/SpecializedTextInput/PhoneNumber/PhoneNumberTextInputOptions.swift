//
//  PhoneNumberTextInputOptions.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public enum PhoneNumberFormat {

    // +12345678901
    case e164

    // +1 (234) 567-8901
    case international

}

public struct PhoneNumberTextInputOptions {

    /// Creates a `PhoneNumberTextInputOptions`.
    ///
    /// - Parameters:
    ///   - format: The phone number format.
    ///   - maxLength: The maximum number of digits in a phone number.
    /// - Returns: The created `PhoneNumberTextInputOptions`.
    public static func options(format: PhoneNumberFormat = .international, maxLength: Int = 11) -> PhoneNumberTextInputOptions {

        // TODO: Verify the lower bound.
        let maxLengthAllowedRange = 11...15

        guard maxLengthAllowedRange.contains(maxLength) else {
            fatalError("The provided value (\(maxLength)) of `maxLength` argument is out of the allowed bounds (\(maxLengthAllowedRange.lowerBound)...\(maxLengthAllowedRange.upperBound)).")
        }

        return self.init(
            format: format,
            maxLength: maxLength
        )
    }

    let format: PhoneNumberFormat

    let maxLength: Int

}
