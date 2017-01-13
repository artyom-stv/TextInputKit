//
//  PhoneNumberTextInputError.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import PhoneNumberKit

public enum PhoneNumberTextInputError : Error {

    public enum InvalidInputDetails {

        case unknown

        case invalidCountryCode

        case tooShort

        case tooLong

        case nationalNumbersAreNotSupported

        case numberExtensionAreNotSupported

    }

    case invalidInput(InvalidInputDetails)

}

extension PhoneNumberTextInputError : CustomStringConvertible {

    public var description: String {
        switch self {
        case .invalidInput(let details):
            var description = "The string isn't representing a valid phone number."

            switch details {
            case .invalidCountryCode:
                description += " The country code is invalid."

            case .tooShort:
                description += " The number is too short."

            case .tooLong:
                description += " The number is too long."

            case .nationalNumbersAreNotSupported:
                description += " Only international numbers (starting with \"+\") are supported."

            case .numberExtensionAreNotSupported:
                description += " Number extensions aren't supported."

            default:
                break
            }

            return description
        }
    }

}

extension PhoneNumberTextInputError {

    static func from(_ error: PhoneNumberError) -> PhoneNumberTextInputError {
        switch error {
        case .invalidCountryCode:
            return .invalidInput(.invalidCountryCode)

        case .tooShort:
            return .invalidInput(.tooShort)

        case .tooLong:
            return .invalidInput(.tooLong)

        default:
            return .invalidInput(.unknown)
        }
    }

}
