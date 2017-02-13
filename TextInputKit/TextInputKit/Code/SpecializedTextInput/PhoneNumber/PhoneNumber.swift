//
//  PhoneNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import PhoneNumberKit

public struct PhoneNumber {

    /// Creates a `PhoneNumber` by a `PhoneNumberKit.PhoneNumber`.
    ///
    /// - Note: For the internally use only.
    ///
    /// - Parameters:
    ///   - pnkPhoneNumber: The `PhoneNumberKit.PhoneNumber`.
    init(_ pnkPhoneNumber: PNKPhoneNumber) {
        self.pnkPhoneNumber = pnkPhoneNumber
    }

    let pnkPhoneNumber: PNKPhoneNumber

}

extension PhoneNumber {

    /// Creates a `PhoneNumber` by string representation.
    ///
    /// - Note: Only international phone numbers (starting with "+") are supported.
    ///
    /// - Parameters:
    ///   - phoneNumberString: A string representing a phone number.
    /// - Throws:
    ///   - `TextInputKitError.missingFramework` if PhoneNumberKit framework isn't loaded.
    ///   - `PhoneNumberTextInputError.invalidInput` if the provided string doesn't represent a valid phone number.
    public init(_ phoneNumberString: String) throws {
        try PhoneNumberKit.checkThatFrameworkIsLoaded()

        if let firstUnicodeScalar = phoneNumberString.unicodeScalars.first, !StringUtils.isPlus(firstUnicodeScalar) {
            throw PhoneNumberTextInputError.nationalNumbersAreNotSupported
        }

        let pnkPhoneNumber: PNKPhoneNumber
        do {
            let phoneNumberKit = PhoneNumberKit.cached.instance
            pnkPhoneNumber = try phoneNumberKit.parse(phoneNumberString)
        } catch let error as PhoneNumberError {
            throw PhoneNumberTextInputError.from(error)
        }

        if pnkPhoneNumber.numberExtension != nil {
            throw PhoneNumberTextInputError.numberExtensionAreNotSupported
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
