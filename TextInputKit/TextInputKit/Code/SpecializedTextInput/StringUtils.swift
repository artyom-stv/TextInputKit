//
//  StringUtils.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 10/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

struct StringUtils {

    private init() {}

}

extension StringUtils {

    static let spaceCharacters = CharacterSet(charactersIn: " \u{3000}\u{00a0}\u{00ad}\u{200b}\u{2060}")

    static let plusCharacters = CharacterSet(charactersIn: "+\u{ff0b}")

    static let slashCharacters = CharacterSet(charactersIn: "/\u{ff0f}")

    static let dashCharacters = CharacterSet(charactersIn: "-\u{2010}\u{2011}\u{2012}\u{2013}\u{2014}\u{2015}\u{2212}\u{30fc}\u{ff0d}")

    static let bracketCharacters = CharacterSet(charactersIn: "[]\u{ff3b}\u{ff3d}")

    static let paranthesisCharacters = CharacterSet(charactersIn: "()\u{ff08}\u{ff09}")

    static let pointCharacters = CharacterSet(charactersIn: ".\u{ff0e}")

    static func isSpace(_ unicodeScalar: UnicodeScalar) -> Bool {
        return spaceCharacters.contains(unicodeScalar)
    }

    static func isDigit(_ unicodeScalar: UnicodeScalar) -> Bool {
        return CharacterSet.decimalDigits.contains(unicodeScalar)
    }

    static func isPlus(_ unicodeScalar: UnicodeScalar) -> Bool {
        return plusCharacters.contains(unicodeScalar)
    }

}

extension StringUtils {

    static func stringView(
        from stringView: String.UnicodeScalarView,
        preservingCharacters: CharacterSet,
        ignoringCharacters: CharacterSet
        ) -> String.UnicodeScalarView? {

        do {
            var resultStringView = "".unicodeScalars
            try scan(String(stringView),
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

        assert((originalRange.lowerBound == originalStringView.endIndex) || originalStringView.indices.contains(originalRange.lowerBound))
        assert((originalRange.upperBound == originalStringView.endIndex) || originalStringView.indices.contains(originalRange.upperBound))

        var resultStringView = "".unicodeScalars

        do {
            if originalRange.lowerBound != originalStringView.startIndex {
                let leftSubstringView = (originalRange.lowerBound == originalStringView.endIndex)
                    ? originalStringView.asSubstringView()
                    : originalStringView.prefix(upTo: originalRange.lowerBound)
                try scan(
                    String(leftSubstringView),
                    preservingCharacters: preservingCharacters,
                    ignoringCharacters: ignoringCharacters,
                    appending: &resultStringView)
            }

            let resultRangeLowerBound = resultStringView.endIndex

            if !originalRange.isEmpty {
                let middleSubstringView = (originalRange.lowerBound == originalStringView.startIndex) && (originalRange.upperBound == originalStringView.endIndex)
                    ? originalStringView.asSubstringView()
                    : originalStringView[originalRange]
                try scan(
                    String(middleSubstringView),
                    preservingCharacters: preservingCharacters,
                    ignoringCharacters: ignoringCharacters,
                    appending: &resultStringView)
            }

            let resultRangeUpperBound = resultStringView.endIndex

            if originalRange.upperBound != originalStringView.endIndex {
                let rightSubstringView = (originalRange.upperBound == originalStringView.startIndex)
                    ? originalStringView.asSubstringView()
                    : originalStringView.suffix(from: originalRange.upperBound)
                try scan(
                    String(rightSubstringView),
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

    private enum ScanError : Error {

        case unexpectedCharacter

    }

    private static func scan(
        _ string: String,
        preservingCharacters: CharacterSet,
        ignoringCharacters: CharacterSet,
        appending resultStringView: inout String.UnicodeScalarView) throws {

        let scanner = Scanner(string: string)
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
