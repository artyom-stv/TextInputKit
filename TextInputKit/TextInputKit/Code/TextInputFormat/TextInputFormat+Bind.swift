//
//  TextInputFormat+Bind.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

/// A class which represents a text input component (e.g., `UITextField`) should implement `TextInputFormatBindable`
/// protocol to be able to be bound to a text input format using the `TextInputFormat.bind(to:)` method.
public protocol TextInputFormatBindable {

    /// Binds a text input format to `self`.
    ///
    /// - Parameters:
    ///   - format: The text input format.
    /// - Returns: The created `TextInputBinding`.
    func bind<Value>(format: TextInputFormat<Value>) -> TextInputBinding<Value>

}

public extension TextInputFormat {

    /// Binds the text input format to a text field, which conforms to `TextInputFormatBindable` protocol.
    ///
    /// - Note:
    ///   This method only delegates the work to the `TextInputFormatBindable` protocol implementation.
    ///
    /// - Parameters:
    ///   - textField: The text field conforming to `TextInputFormatBindable` protocol.
    /// - Returns: The created `TextInputBinding`.
    func bind<TextField: TextInputFormatBindable>(to textField: TextField) -> TextInputBinding<Value> {
        return textField.bind(format: self)
    }

}
