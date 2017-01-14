//
//  BankCardNumberUtils.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 30/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

struct BankCardNumberUtils {

    private init() {}

}

extension BankCardNumberUtils {

    static func cardNumberDigitsStringView(
        from stringView: String.UnicodeScalarView
        ) -> String.UnicodeScalarView? {

        return StringUtils.stringView(
            from: stringView,
            preservingCharacters: CharacterSet.decimalDigits,
            ignoringCharacters: cardNumberWhitespaces)
    }

    static func cardNumberDigitsStringViewAndRange(
        from stringView: String.UnicodeScalarView,
        range: Range<String.UnicodeScalarIndex>
        ) -> (String.UnicodeScalarView, Range<String.UnicodeScalarIndex>)? {

        return StringUtils.stringViewAndRange(
            from: stringView,
            range: range,
            preservingCharacters: CharacterSet.decimalDigits,
            ignoringCharacters: cardNumberWhitespaces)
    }

    private static let cardNumberWhitespaces = CharacterSet(charactersIn: " ")

}

extension BankCardNumberUtils {

    static func cardNumberStringView(
        fromDigits digitsStringView: String.UnicodeScalarView,
        withLength digitsStringViewLength: Int,
        sortedSpacesPositions: [Int]) -> String.UnicodeScalarView {

        // TODO: Optimize the implementation.

        precondition(String(digitsStringView).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil)
        precondition(digitsStringView.count == digitsStringViewLength)
        precondition(sortedSpacesPositions.sorted() == sortedSpacesPositions)

        var cardNumberStringView = "".unicodeScalars
        cardNumberStringView.reserveCapacity(digitsStringViewLength + sortedSpacesPositions.count)

        var spacesPositionsIterator = sortedSpacesPositions.makeIterator()
        var nextSpacePosition: Int? = spacesPositionsIterator.next()
        for (position, character) in digitsStringView.enumerated() {
            if let spacePosition: Int = nextSpacePosition, spacePosition == position {
                cardNumberStringView.append(UnicodeScalar(" "))
                nextSpacePosition = spacesPositionsIterator.next()
            }

            cardNumberStringView.append(character)
        }

        return cardNumberStringView
    }

    static func cardNumberStringViewAndIndex(
        fromDigits digitsStringView: String.UnicodeScalarView,
        withLength digitsStringViewLength: Int,
        index digitsStringViewIndex: String.UnicodeScalarIndex,
        sortedSpacesPositions: [Int]) -> (String.UnicodeScalarView, String.UnicodeScalarIndex) {

        precondition(String(digitsStringView).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil)
        precondition(digitsStringView.count == digitsStringViewLength)
        precondition(digitsStringViewIndex >= digitsStringView.startIndex && digitsStringViewIndex <= digitsStringView.endIndex)
        precondition(sortedSpacesPositions.sorted() == sortedSpacesPositions)

        var cardNumberStringView = "".unicodeScalars
        cardNumberStringView.reserveCapacity(digitsStringViewLength + sortedSpacesPositions.count)

        var resultingIndex = cardNumberStringView.startIndex

        var spacesPositionsIterator = sortedSpacesPositions.makeIterator()
        var nextSpacePosition = spacesPositionsIterator.next()
        for (index, positionAndCharacter) in zip(digitsStringView.indices, digitsStringView.enumerated()) {
            let (position, character) = positionAndCharacter

            if index == digitsStringViewIndex {
                resultingIndex = cardNumberStringView.endIndex
            }

            if let spacePosition = nextSpacePosition, spacePosition == position {
                cardNumberStringView.append(UnicodeScalar(" "))
                nextSpacePosition = spacesPositionsIterator.next()
            }

            cardNumberStringView.append(character)
        }

        if digitsStringViewIndex == digitsStringView.endIndex {
            resultingIndex = cardNumberStringView.endIndex
        }
        
        return (cardNumberStringView, resultingIndex)
    }

}

extension BankCardNumberUtils {

    struct IinRangeInfo {

        let range: CountableClosedRange<Int>

        let cardBrand: BankCardBrand

        let maxCardNumberLength: Int

        fileprivate init(_ range: CountableClosedRange<Int>, _ cardBrand: BankCardBrand, _ maxCardNumberLength: Int) {
            self.range = range
            self.cardBrand = cardBrand
            self.maxCardNumberLength = maxCardNumberLength
        }
        
    }

    /// Determines a range of IINs which may correspond to a partial of full bank card number.
    ///
    /// - Parameters:
    ///   - digitsString: A string of digits representing a bank card number.
    ///   - digitsStringLength: Length of `digitsString`. Passed here for an optimization purpose (not to recalculate the length several times).
    /// - Returns:
    ///   Range of IINs which may correspond to a partial of full bank card number represented by a string of digits.
    ///   In a special case when `digitsStringLength` is greater or equal to 6, the returned range contains only one IIN.
    ///
    /// - SeeAlso:
    ///   [Issuer identification number (IIN)](https://en.wikipedia.org/wiki/Payment_card_number#Issuer_identification_number_.28IIN.29)
    static func iinRange(
        fromDigitsString digitsString: String,
        withLength digitsStringLength: Int) -> Range<Int> {

        precondition(digitsString.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil)
        precondition(digitsString.characters.count == digitsStringLength)

        let iinRangeStart: Int = {
            let iinString = digitsStringLength == iinLength
                ? digitsString
                : digitsString.padding(toLength: iinLength, withPad: "0", startingAt: 0)
            return Int(iinString)!
        }()

        let iinRangeLength: Int = {
            var iinRangeLength = 1
            if digitsStringLength < iinLength {
                for _ in CountableRange(uncheckedBounds: (lower: 0, upper: iinLength - digitsStringLength)) {
                    iinRangeLength = iinRangeLength &* 10
                }
            }
            return iinRangeLength
        }()

        return iinRangeStart ..< (iinRangeStart + iinRangeLength)
    }

    static func info(forIinRange iinRange: Range<Int>) -> IinRangeInfo? {
        let iinRange = ClosedRange(iinRange)
        guard let index = iinRangesInfo.index(where: { $0.range.contains(iinRange) }) else {
            return nil
        }
        return iinRangesInfo[index]
    }

    private static let iinLength = 6

    private static let iinRangesInfo: [IinRangeInfo] = [
        // TODO: Fill the missing ranges (if they are allocated).
        .init(100000...199999, .uatp,       15),
//        .init(200000...222099, ., 16),
        .init(222100...272099, .masterCard, 16),
//        .init(272100...299999, ., 16),
        .init(300000...305999, .dinersClub, 14),
//        .init(306000...308999, ., 16),
        .init(309000...309999, .dinersClub, 14),
//        .init(310000...339999, ., 16),
        .init(340000...349999, .amex,       15),
//        .init(350000...352799, ., 16),
        .init(352800...358999, .jcb,        16),
//        .init(359000...359999, ., 16),
        .init(360000...369999, .dinersClub, 14),
        .init(370000...379999, .amex,       15),
        .init(380000...399999, .dinersClub, 14),
        .init(400000...499999, .visa,       16),
        .init(500000...509999, .maestro,    16),
        .init(510000...559999, .masterCard, 16),
        .init(560000...599999, .maestro,    16),
//        .init(600000...601099, ., 16),
        .init(601100...601199, .discover,   16),
//        .init(601200...609999, ., 16),
        .init(610000...619999, .maestro,    16),
        .init(620000...629999, .unionPay,   16), // 19?
        .init(630000...639999, .maestro,    16),
//        .init(640000...643999, ., 16),
        .init(644000...659999, .discover,   16),
        .init(660000...699999, .maestro,    16),
//        .init(700000...799999, ., 16),
//        .init(800000...879999, ., 16),
        .init(880000...889999, .unionPay,   16),
//        .init(890000...899999, ., 16),
//        .init(900000...999999, ., 16),
    ]

}

extension BankCardNumberUtils {

    static func sortedSpacesPositions(for cardBrand: BankCardBrand?) -> [Int] {
        switch cardBrand {
        case .some(.uatp):
            return [4, 9]

        case .some(.amex):
            return [4, 10]

        default:
            return [4, 8, 12]
        }
    }

}
