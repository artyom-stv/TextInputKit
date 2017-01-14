//
//  FormatterObjectValue.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// The type which is used in a `Formatter` created by `toFormatter()` method of `TextInputFormat`.
///
/// After finishing editing an `NSTextField`, if the `objectValue` is nil, the `stringValue` of an `NSTextField`
/// is reset. To eliminate such behavior, if the `objectValue` is nil, the text is stored in the `objectValue`
/// (in a `FormatterObjectValue`) and then returned from `Formatter.string(for:)`.
public struct FormatterObjectValue<Value> {

    /// The `Value` or nil.
    public let value: Value?

    /// The text in the text input.
    public let text: String

    public init(value: Value? = nil, text: String = "") {
        self.value = value
        self.text = text
    }
    
}
