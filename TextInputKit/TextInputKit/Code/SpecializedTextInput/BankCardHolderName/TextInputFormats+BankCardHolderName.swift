//
//  TextInputFormats+BankCardHolderName.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

public extension TextInputFormats {

    /// Creates a `TextInputFormat` with `String` value type.
    /// The created `TextInputFormat` implements formatting of bank card holder name text input.
    ///
    /// - Parameter options: The text input options.
    /// - Returns: Text input format for bank card holder name.
    static func bankCardHolderName(_ options: BankCardHolderNameTextInputOptions = .options()) -> TextInputFormat<String> {
        let formatter = BankCardHolderNameTextInputFormatter(options)

        return TextInputFormat<String>.from(.identical, formatter)
    }
    
}
