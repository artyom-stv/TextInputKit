//
//  TextInputSerializerType+Map.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputSerializerType {

    public typealias MapDirectTransform<Result> = (Value) throws -> Result
    public typealias MapReverseTransform<Result> = (Result) -> Value

    func map<Result>(
        direct directTransform: @escaping MapDirectTransform<Result>,
        reverse reverseTransform: @escaping MapReverseTransform<Result>) -> TextInputSerializer<Result> {

        return Map(source: self, direct: directTransform, reverse: reverseTransform)
    }

}

private final class Map<SourceSerializer: TextInputSerializerType, Result> : TextInputSerializer<Result> {

    typealias MapDirectTransform = (SourceSerializer.Value) throws -> Result
    typealias MapReverseTransform = (Result) -> SourceSerializer.Value

    init(source sourceSerializer: SourceSerializer,
         direct directTransform: @escaping MapDirectTransform,
         reverse reverseTransform: @escaping MapReverseTransform) {

        self.sourceSerializer = sourceSerializer
        self.directTransform = directTransform
        self.reverseTransform = reverseTransform
    }

    override func string(for value: Result) -> String {
        return sourceSerializer.string(for: reverseTransform(value))
    }

    override func value(for string: String) throws -> Result {
        return try directTransform(try sourceSerializer.value(for: string))
    }

    let sourceSerializer: SourceSerializer
    let directTransform: MapDirectTransform
    let reverseTransform: MapReverseTransform

}
