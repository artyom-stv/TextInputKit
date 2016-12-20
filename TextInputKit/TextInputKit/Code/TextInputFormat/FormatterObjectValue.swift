//
//  FormatterObjectValue.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// The wrapper type, which is used in a `Formatter` created by the `toFormatter()` method of `TextInputFormat`.
///
/// - value: The `Value`. This case is used when a value is present.
/// - string: The text in the text input. This case is used when there is no `Value` representing the text.
public enum FormatterObjectValue<Value> {

    case value(Value)

    case string(String)
    
}
