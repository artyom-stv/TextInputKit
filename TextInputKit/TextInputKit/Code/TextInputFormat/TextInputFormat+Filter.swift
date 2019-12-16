//
//  TextInputFormat+Filter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormat {

    // The commented code crashes the compiler.
//    public typealias FilterPredicate = TextInputFormatterType.FilterPredicate

    typealias FilterPredicate = (String) -> Bool

    /// Creates a `TextInputFormat` which filters the output of the source formatter
    /// (the formatter of the callee format).
    ///
    /// - Parameters:
    ///   - predicate: The predicate which is used to filter the output of the source formatter.
    /// - Returns: The created `TextInputFormat`.
    func filter(_ predicate: @escaping FilterPredicate) -> TextInputFormat<Value> {
        return TextInputFormat.from(
            self.serializer,
            self.formatter.filter(predicate))
    }
    
}

public extension TextInputFormat {

    /// Creates a `TextInputFormat` with a formatter which rejects the output of the source formatter
    /// (the formatter of the callee format) if the output contains characters out of the `characterSet`.
    ///
    /// - Parameters:
    ///   - characterSet: The character set which is used to filter the output of the source formatter.
    /// - Returns: The created `TextInputFormat`.
    func filter(by characterSet: CharacterSet) -> TextInputFormat<Value> {
        let invertedCharacterSet = characterSet.inverted
        return filter {
            string in

            return string.rangeOfCharacter(from: invertedCharacterSet) == nil
        }
    }

    /// Creates a `TextInputFormat` with a formatter which rejects the output of the source formatter
    /// (the formatter of the callee format) if the output exceeds the `maxCharactersCount` limit.
    ///
    /// - Parameters:
    ///   - maxCharactersCount: The maximum characters count which is used to filter the output of the source formatter.
    /// - Returns: The created `TextInputFormat`.
    func filter(constrainingCharactersCount maxCharactersCount: Int) -> TextInputFormat<Value> {
        return filter {
            string in

            return (string.count <= maxCharactersCount)
        }
    }

}
