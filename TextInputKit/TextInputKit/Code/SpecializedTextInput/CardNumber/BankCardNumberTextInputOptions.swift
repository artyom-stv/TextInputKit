//
//  BankCardNumberTextInputOptions.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// Options for text input of bank card numbers.
public struct BankCardNumberTextInputOptions {

    /// Creates a `BankCardNumberTextInputOptions`.
    ///
    /// - Parameters:
    ///   - maxLength: The maximum number of digits in a bank card number.
    /// - Returns: The created `BankCardNumberTextInputOptions`.
    public static func options(
        maxLength: Int = 19
        ) -> BankCardNumberTextInputOptions {

        let maxLengthAllowedRange = 12...19

        guard maxLengthAllowedRange.contains(maxLength) else {
            fatalError("The provided value (\(maxLength)) of `maxLength` argument is out of the allowed bounds (\(maxLengthAllowedRange.lowerBound)...\(maxLengthAllowedRange.upperBound)).")
        }

        return self.init(
            maxLength: maxLength
        )
    }

    let maxLength: Int

}
