//
//  BankCardNumberTextInputOptions.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// Options for text input of bank card numbers.
///
/// - note:
///   Currently, there are no properties in `BankCardNumberTextInputOptions` struct.
///   It is left for future text input customizations not breaking the API.
public struct BankCardNumberTextInputOptions {

    public static func options() -> BankCardNumberTextInputOptions {
        return self.init()
    }

}
