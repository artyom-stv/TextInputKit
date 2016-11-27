//
//  TextInputSerializerType+Formatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 23/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputSerializerType {

    static func from<Value>(_ formatter: Formatter, valueClass: Value.Type) -> TextInputSerializer<Value> {
        return TextInputSerializerFromFormatter<Value>(formatter)
    }

}

final class TextInputSerializerFromFormatter<Value> : TextInputSerializer<Value> {

    init(_ formatter: Formatter) {
        self.formatter = formatter
    }

    func string(for value: Value) -> String? {
        return formatter.editingString(for: value) ?? ""
    }

    override func value(for string: String) throws -> Value {
        var optionalObject: AnyObject?
        var errorDescription: NSString?
        guard formatter.getObjectValue(&optionalObject, for: string, errorDescription: &errorDescription) else {
            // TODO: Throw proper error.
            throw TextInputKitError.unknown
        }

        guard let object = optionalObject else {
            fatalError("Formatter.getObjectValue(_:for:errorDescription:) returned true but didn't assign an object.")
        }

        guard let value = object as? Value else {
            fatalError("Unexpected type of an object assigned by Formatter.getObjectValue(_:for:errorDescription:) (expected: \(String(describing: Value.self)), actual: \(String(describing: type(of: object))))")
        }

        return value
    }

    private let formatter: Formatter
    
}
