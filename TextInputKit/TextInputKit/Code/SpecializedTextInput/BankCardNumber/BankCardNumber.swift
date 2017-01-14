//
//  BankCardNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct BankCardNumber {

    /// An error thrown by `BankCardNumber` initializers.
    ///
    /// - unexpectedCharacters: The provided string contains unexpected characters.
    public enum InitializationError : Error {

        case unexpectedCharacters

    }

    public let digitsString: String

    public let formattedString: String

    public let cardBrand: BankCardBrand?

    /// Creates a `BankCardNumber` by string representation.
    ///
    /// - Parameters:
    ///   - digitsString: The string of digits which represents a bank card number.
    /// - Throws: `InitializationError.unexpectedCharacters` if the provided string contains non-digit characters.
    public init(digitsString: String) throws {
        guard digitsString.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            throw InitializationError.unexpectedCharacters
        }

        let digitsStringView = digitsString.unicodeScalars
        let digitsStringLength = digitsStringView.count

        let iinRange = Utils.iinRange(
            fromDigitsString: digitsString,
            withLength: digitsStringLength)
        let iinRangeInfo = Utils.info(forIinRange: iinRange)
        let sortedSpacesPositions = Utils.sortedSpacesPositions(for: iinRangeInfo?.cardBrand)

        let formattedStringView = Utils.cardNumberStringView(
            fromDigits: digitsStringView,
            withLength: digitsStringLength,
            sortedSpacesPositions: sortedSpacesPositions)

        self.init(
            digitsString: digitsString,
            formattedString: String(formattedStringView),
            cardBrand: iinRangeInfo?.cardBrand)
    }

    fileprivate typealias Utils = BankCardNumberUtils

    /// The memberwise initializer with reduced access level.
    fileprivate init(
        digitsString: String,
        formattedString: String,
        cardBrand: BankCardBrand?) {

        self.digitsString = digitsString
        self.formattedString = formattedString
        self.cardBrand = cardBrand
    }

}

extension BankCardNumber {

    /// Creates a `BankCardNumber` by a formatted string which represents a bank card number.
    ///
    /// - Note: Used internally only.
    ///
    /// - Parameters:
    ///   - formattedString: The formatted string which represents a bank card number.
    init(formattedString: String) {
        guard let digitsStringView = Utils.cardNumberDigitsStringView(from: formattedString.unicodeScalars) else {
            fatalError("Unexpected characters in `formattedString` argument.")
        }

        let digitsString = String(digitsStringView)
        // Length of ASCII string is similar in `characters` and in `unicodeScalars`.
        let digitsStringLength = digitsStringView.count

        let iinRange = Utils.iinRange(
            fromDigitsString: digitsString,
            withLength: digitsStringLength)
        let iinRangeInfo = Utils.info(forIinRange: iinRange)

        self.init(
            digitsString: digitsString,
            formattedString: formattedString,
            cardBrand: iinRangeInfo?.cardBrand)
    }
    
}

extension BankCardNumber : Equatable {

    public static func ==(lhs: BankCardNumber, rhs: BankCardNumber) -> Bool {
        return lhs.digitsString == rhs.digitsString
    }

}

extension BankCardNumber : Hashable {

    public var hashValue: Int {
        return digitsString.hashValue
    }
    
}
