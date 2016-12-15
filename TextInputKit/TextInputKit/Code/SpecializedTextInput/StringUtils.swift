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
