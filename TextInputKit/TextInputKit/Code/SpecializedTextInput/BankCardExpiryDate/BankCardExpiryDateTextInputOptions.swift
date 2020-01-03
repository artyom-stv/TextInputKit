//
//  BankCardExpiryDateTextInputOptions.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// The options for text input of bank card expiry dates.
///
/// - Note:
///   Currently, there are no properties in `BankCardExpiryDateTextInputOptions`.
///   For the future purpose, `BankCardExpiryDateTextInputOptions` is left to customize text input formatting without
///   breaking the API backward compatibility.
public struct BankCardExpiryDateTextInputOptions {

    /// Creates `BankCardExpiryDateTextInputOptions`.
    ///
    /// - Returns: The created `BankCardExpiryDateTextInputOptions`.
    public static func options() -> BankCardExpiryDateTextInputOptions {
        return BankCardExpiryDateTextInputOptions()
    }

}
