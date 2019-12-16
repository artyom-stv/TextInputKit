//
//  TextInputFormat+Map.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormat {

    // The commented code crashes the compiler.
//    public typealias MapTransform = TextInputFormatterType.MapTransform

    typealias MapTransform = (String, Range<String.Index>) -> (String, Range<String.Index>)

    /// Creates a `TextInputFormat` which transforms the output of the source formatter
    /// (the formatter of the callee format).
    ///
    /// - Parameters:
    ///   - transform: The transformation.
    /// - Returns: The created `TextInputFormatter`.
    func map(_ transform: @escaping MapTransform) -> TextInputFormat<Value> {
        return TextInputFormat.from(
            self.serializer,
            self.formatter.map(transform))
    }

}

public extension TextInputFormat {

    /// Creates a `TextInputFormat` with a formatter which trims the output of the source formatter
    /// (the formatter of the callee format) by the `maxCharactersCount`.
    ///
    /// - Parameters:
    ///   - maxCharactersCount: The maximum characters count which is used to trim the output of the source formatter.
    /// - Returns: The created `TextInputFormatter`.
    func map(constrainingCharactersCount maxCharactersCount: Int) -> TextInputFormat<Value> {
        return map {
            (string, selectedRange) in

            let resultEndIndex = string.index(string.startIndex, offsetBy: maxCharactersCount, limitedBy: string.endIndex)
            if let resultEndIndex = resultEndIndex, resultEndIndex != string.endIndex {
                let newString = String(string[..<resultEndIndex])
                let newSelectedRange = selectedRange.clamped(to: string.startIndex..<resultEndIndex)

                return (newString, newSelectedRange)
            }

            return (string, selectedRange)
        }
    }

}
