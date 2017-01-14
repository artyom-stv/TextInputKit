//
//  BankCardNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct BankCardNumber {

    public let digitsString: String

    public let formattedString: String

    public let cardBrand: BankCardBrand?

    fileprivate typealias Utils = BankCardNumberUtils

    fileprivate init(
        digitsString: String,
        formattedString: String,
        cardBrand: BankCardBrand?) {

        self.digitsString = digitsString
        self.formattedString = formattedString
        self.cardBrand = cardBrand
    }

}

public extension BankCardNumber {

    public init(digitsString: String) {
        guard digitsString.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            fatalError("Bank card number should contain only decimal digits.")
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

}

extension BankCardNumber {

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
