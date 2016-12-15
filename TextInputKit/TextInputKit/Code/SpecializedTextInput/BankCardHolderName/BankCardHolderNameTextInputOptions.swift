//
//  BankCardHolderNameTextInputOptions.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

/// Options for text input of bank card numbers.
///
/// - Note:
///   Currently, there are no properties in `BankCardHolderNameTextInputOptions` struct.
///   It is left for future text input customizations not breaking the API.
public struct BankCardHolderNameTextInputOptions {

    public static func options() -> BankCardHolderNameTextInputOptions {
        return self.init()
    }

}
