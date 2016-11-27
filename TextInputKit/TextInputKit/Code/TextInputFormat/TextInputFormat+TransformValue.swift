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

    func transformValue<Result>(
        direct directTransform: @escaping DirectValueTransform<Result>,
        reverse reverseTransform: @escaping ReverseValueTransform<Result>) -> TextInputFormat<Result> {

        return TextInputFormat.from(
            self.serializer.map(direct: directTransform, reverse: reverseTransform),
            self.formatter)
    }

}
