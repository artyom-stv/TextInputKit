//
//  BankCardNumberUtils.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 30/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

struct BankCardNumberUtils {

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

    static func cardNumberDigitsStringView(
        from stringView: String.UnicodeScalarView
        ) -> String.UnicodeScalarView? {

        return self.stringView(
            from: stringView,
            preservingCharacters: CharacterSet.decimalDigits,
            ignoringCharacters: CharacterSet.whitespaces)
    }

    static func cardNumberDigitsStringViewAndRange(
        from stringView: String.UnicodeScalarView,
        range: Range<String.UnicodeScalarIndex>
        ) -> (String.UnicodeScalarView, Range<String.UnicodeScalarIndex>)? {

        return self.stringViewAndRange(
            from: stringView,
            range: range,
            preservingCharacters: CharacterSet.decimalDigits,
            ignoringCharacters: CharacterSet.whitespaces)
    }

    static func stringView(
        from stringView: String.UnicodeScalarView,
        preservingCharacters: CharacterSet,
        ignoringCharacters: CharacterSet
        ) -> String.UnicodeScalarView? {

        do {
            var resultStringView = "".unicodeScalars
            try scan(stringView,
                preservingCharacters: preservingCharacters,
                ignoringCharacters: ignoringCharacters,
                appending: &resultStringView)

            return resultStringView
        }
        catch {
            return nil
        }
    }

    static func stringViewAndRange(
        from originalStringView: String.UnicodeScalarView,
        range originalRange: Range<String.UnicodeScalarIndex>,
        preservingCharacters: CharacterSet,
        ignoringCharacters: CharacterSet
        ) -> (String.UnicodeScalarView, Range<String.UnicodeScalarIndex>)? {

        precondition((originalRange.lowerBound == originalStringView.endIndex) || originalStringView.indices.contains(originalRange.lowerBound))
        precondition((originalRange.upperBound == originalStringView.endIndex) || originalStringView.indices.contains(originalRange.upperBound))

        var resultStringView = "".unicodeScalars

        do {
            if originalRange.lowerBound != originalStringView.startIndex {
                let leftSubstringView = (originalRange.lowerBound == originalStringView.endIndex)
                    ? originalStringView
                    : originalStringView.prefix(upTo: originalRange.lowerBound)
                try scan(
                    leftSubstringView,
                    preservingCharacters: preservingCharacters,
                    ignoringCharacters: ignoringCharacters,
                    appending: &resultStringView)
            }

            let resultRangeLowerBound = resultStringView.endIndex

            if !originalRange.isEmpty {
                let middleSubstringView = (originalRange.lowerBound == originalStringView.startIndex) && (originalRange.upperBound == originalStringView.endIndex)
                    ? originalStringView
                    : originalStringView[originalRange]
                try scan(
                    middleSubstringView,
                    preservingCharacters: preservingCharacters,
                    ignoringCharacters: ignoringCharacters,
                    appending: &resultStringView)
            }

            let resultRangeUpperBound = resultStringView.endIndex

            if originalRange.upperBound != originalStringView.endIndex {
                let rightSubstringView = (originalRange.upperBound == originalStringView.startIndex)
                    ? originalStringView
                    : originalStringView.suffix(from: originalRange.upperBound)
                try scan(
                    rightSubstringView,
                    preservingCharacters: preservingCharacters,
                    ignoringCharacters: ignoringCharacters,
                    appending: &resultStringView)
            }

            return (resultStringView, resultRangeLowerBound..<resultRangeUpperBound)
        }
        catch {
            return nil
        }
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

    private static let iinLength = 6

    // TODO: Fill the missing ranges (if they are allocated).
    private static let iinRangesInfo: [IinRangeInfo] = [
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

    private static let cardNumberWhitespaces = CharacterSet(charactersIn: " ")

    private init() {}

    private enum ScanError : Error {

        case unexpectedCharacter

    }

    private static func scan(
        _ stringView: String.UnicodeScalarView,
        preservingCharacters: CharacterSet,
        ignoringCharacters: CharacterSet,
        appending resultStringView: inout String.UnicodeScalarView) throws {

        let scanner = Scanner(string: String(stringView))
        scanner.charactersToBeSkipped = ignoringCharacters
        while !scanner.isAtEnd {
            var partialNSString: NSString?
            if !scanner.scanCharacters(from: preservingCharacters, into: &partialNSString) {
                throw ScanError.unexpectedCharacter
            }
            resultStringView.append(contentsOf: (partialNSString! as String).unicodeScalars)
        }
    }

}
