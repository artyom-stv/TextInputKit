//
//  PhoneNumberTextInputError.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import PhoneNumberKit

/// An error thrown while converting a string to a `PhoneNumber`: the string doesn't represent a valid phone number,
/// or the represented phone number isn't supported by TextInputKit.
///
/// - unknown: Unknown error.
/// - invalidCountryCode: The string contains a phone number with the invalid country code.
/// - tooShort: The string contains a phone number which is too short.
/// - tooLong: The string contains a phone number which is too short.
/// - nationalNumbersAreNotSupported: The string contains a national phone number,
///   but TextInputKit currently supports only international numbers (starting with \"+\").
/// - numberExtensionAreNotSupported: The string contains a phone number with extension,
///   but TextInputKit currently doesn't supports number extensions.
public enum PhoneNumberTextInputError : Error {

    case unknown

    case invalidCountryCode

    case tooShort

    case tooLong

    case nationalNumbersAreNotSupported

    case numberExtensionAreNotSupported

}

extension PhoneNumberTextInputError: CustomStringConvertible {

    public var description: String {
        switch self {
        case .unknown:
            return "The string doesn't represent a valid phone number."

        case .invalidCountryCode:
            return "The string doesn't represent a valid phone number: the country code is invalid."

        case .tooShort:
            return "The string doesn't represent a valid phone number: the number is too short."

        case .tooLong:
            return "The string doesn't represent a valid phone number: the number is too long."

        case .nationalNumbersAreNotSupported:
            return "National phone numbers (not starting with \"+\") aren't supported."

        case .numberExtensionAreNotSupported:
            return "Phone number extensions aren't supported."
        }
    }

}

extension PhoneNumberTextInputError {

    /// Creates a `PhoneNumberTextInputError` corresponding to a `PhoneNumberKit.PhoneNumberError`.
    ///
    /// - Parameters:
    ///   - error: The `PhoneNumberKit.PhoneNumberError`.
    /// - Returns: The created `PhoneNumberTextInputError`.
    static func from(_ error: PhoneNumberError) -> PhoneNumberTextInputError {
        switch error {
        case .invalidCountryCode:
            return .invalidCountryCode

        case .tooShort:
            return .tooShort

        case .tooLong:
            return .tooLong

        default:
            return .unknown
        }
    }

}
