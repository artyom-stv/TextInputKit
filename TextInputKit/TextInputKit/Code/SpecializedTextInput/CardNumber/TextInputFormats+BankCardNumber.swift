//
//  TextInputFormats+BankCardNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

public extension TextInputFormats {

    /// Creates a `TextInputFormat` with `BankCardNumber` value type.
    /// The created `TextInputFormat` implements formatting of bank card number text input and convertion of text input to `BankCardNumber` struct.
    ///
    /// - Parameter options: The text input options.
    /// - Returns: Text input format for bank card numbers
    static func bankCardNumber(_ options: BankCardNumberTextInputOptions = .options()) -> TextInputFormat<BankCardNumber> {
        let serializer = TextInputSerializer.identical.map(
            direct: { BankCardNumber(formattedString: $0) },
            reverse: { $0.formattedString })

        let formatter = BankCardNumberTextInputFormatter(options)

        return TextInputFormat<String>.from(serializer, formatter)
    }
    
}
