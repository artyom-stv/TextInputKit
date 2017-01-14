//
//  TextInputFormats+BankCardExpiryDate.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormats {

    /// Creates a `TextInputFormat` with `BankCardExpiryDate` value type.
    /// The created `TextInputFormat` implements formatting of bank card expiry date text input and convertion
    /// of text input to `BankCardExpiryDate`.
    ///
    /// - Parameters:
    ///   - options: The text input options.
    /// - Returns: The created `TextInputFormat`.
    static func bankCardExpiryDate(_ options: BankCardExpiryDateTextInputOptions = .options()) -> TextInputFormat<BankCardExpiryDate> {
        let serializer = BankCardExpiryDateTextInputSerializer(options)
        let formatter = BankCardExpiryDateTextInputFormatter(options)

        return TextInputFormat<String>.from(serializer, formatter)
    }
    
}
