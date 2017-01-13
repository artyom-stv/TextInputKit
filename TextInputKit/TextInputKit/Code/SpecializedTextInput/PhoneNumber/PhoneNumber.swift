//
//  PhoneNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import PhoneNumberKit

public struct PhoneNumber {

    init(_ pnkPhoneNumber: PNKPhoneNumber) {
        self.pnkPhoneNumber = pnkPhoneNumber
    }

    let pnkPhoneNumber: PNKPhoneNumber

}

extension PhoneNumber {

    /// Creates a `PhoneNumber` by a phone number string.
    ///
    /// - Note: Only phone numbers starting with "+" are supported.
    ///
    /// - Parameters:
    ///   - phoneNumberString: A string representing a phone number.
    /// - Throws:
    ///   - `TextInputKitError.missingFramework` if PhoneNumberKit framework isn't loaded.
    ///   - `PhoneNumberTextInputError.invalidInput` if the provided string doesn't represent a valid phone number.
    public init(_ phoneNumberString: String) throws {
        try PhoneNumberKit.checkThatFrameworkIsLoaded()

        if let firstUnicodeScalar = phoneNumberString.unicodeScalars.first, !StringUtils.isPlus(firstUnicodeScalar) {
            throw PhoneNumberTextInputError.invalidInput(.nationalNumbersAreNotSupported)
        }

        let pnkPhoneNumber: PNKPhoneNumber
        do {
            let phoneNumberKit = PhoneNumberKit.cached.instance
            pnkPhoneNumber = try phoneNumberKit.parse(phoneNumberString)
        } catch let error as PhoneNumberError {
            throw PhoneNumberTextInputError.from(error)
        }

        if pnkPhoneNumber.numberExtension != nil {
            throw PhoneNumberTextInputError.invalidInput(.numberExtensionAreNotSupported)
        }

        self.init(pnkPhoneNumber)
    }

}

extension PhoneNumber : Equatable {

    public static func ==(lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        return lhs.pnkPhoneNumber == rhs.pnkPhoneNumber
    }

}

extension PhoneNumber : Hashable {

    public var hashValue: Int {
        return pnkPhoneNumber.hashValue
    }

}
