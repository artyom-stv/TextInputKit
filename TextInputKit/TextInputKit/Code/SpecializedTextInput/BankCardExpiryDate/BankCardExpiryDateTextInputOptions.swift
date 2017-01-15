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
///   This struct is left for future text input customizations, which won't break the API.
public struct BankCardExpiryDateTextInputOptions {

    public static func options() -> BankCardExpiryDateTextInputOptions {
        return self.init()
    }

}
