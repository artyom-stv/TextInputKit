//
//  BankCardHolderNameTextInputOptions.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// Options for text input of bank card numbers.
public struct BankCardHolderNameTextInputOptions {

    let maxLength: Int

    /// Creates a `BankCardHolderNameTextInputOptions` for `TextInputFormats.bankCardHolderName(_:)`.
    ///
    /// - Parameters:
    ///   - maxLength: The maximum length of a bank card holder name.
    /// - Returns: The created `BankCardHolderNameTextInputOptions`.
    public static func options(
        maxLength: Int = 26
        ) -> BankCardHolderNameTextInputOptions {

        return self.init(
            maxLength: maxLength
        )
    }

}
