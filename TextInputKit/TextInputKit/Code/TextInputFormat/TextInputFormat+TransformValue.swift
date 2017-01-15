//
//  TextInputFormat+TransformValue.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 27/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormat {

    public typealias DirectValueTransform<Result> = (Value) throws -> Result
    public typealias ReverseValueTransform<Result> = (Result) -> Value

    /// Creates a `TextInputFormat` which transforms the values produced by the source serializer
    /// (the serializer of the callee format).
    ///
    /// - Parameters:
    ///   - directTransform: The transformation from a source value to a resulting value.
    ///   - reverseTransform: The transformation from a resulting value to a source value.
    /// - Returns: The created `TextInputFormatter`.
    func transformValue<Result>(
        direct directTransform: @escaping DirectValueTransform<Result>,
        reverse reverseTransform: @escaping ReverseValueTransform<Result>) -> TextInputFormat<Result> {

        return TextInputFormat.from(
            self.serializer.map(direct: directTransform, reverse: reverseTransform),
            self.formatter)
    }

}

public extension TextInputFormat {

    public typealias NonThrowingDirectValueTransform<Result> = (Value) -> Result?

    /// Creates a `TextInputFormat` which transforms the values produced by the source serializer
    /// (the serializer of the callee format).
    ///
    /// - Parameters:
    ///   - directTransform: The transformation from a source value to a resulting value.
    ///   - reverseTransform: The transformation from a resulting value to a source value.
    /// - Returns: The created `TextInputFormatter`.
    func transformValue<Result>(
        direct nonThrowingDirectTransform: @escaping NonThrowingDirectValueTransform<Result>,
        reverse reverseTransform: @escaping ReverseValueTransform<Result>) -> TextInputFormat<Result> {

        let directTransform: DirectValueTransform<Result> = { value in
            guard let result = nonThrowingDirectTransform(value) else {
                throw TextInputKitError.unknown
            }
            return result
        }

        return TextInputFormat.from(
            self.serializer.map(direct: directTransform, reverse: reverseTransform),
            self.formatter)
    }

}
