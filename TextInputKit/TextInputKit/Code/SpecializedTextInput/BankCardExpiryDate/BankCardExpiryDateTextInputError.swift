//
//  BankCardExpiryDateTextInputError.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// An error thrown while converting a string to a `BankCardExpiryDate`: the string doesn't represent
/// a valid bank card expiry date.
///
/// - incompleteInput: The string doesn't contain "/", otherwise the month or the year component is incomplete.
/// - invalidMonth: The month component of the string doesn't represent a valid month (doesn't fit 1...12).
public enum BankCardExpiryDateTextInputError : Error {

    case incompleteInput

    case invalidMonth

}

extension BankCardExpiryDateTextInputError: CustomStringConvertible {

    public var description: String {
        switch self {
        case .incompleteInput:
            return "The string doesn't represent a valid bank card expiry date."

        case .invalidMonth:
            return "The string doesn't represent a valid bank card expiry date: invalid month."
        }
    }

}
