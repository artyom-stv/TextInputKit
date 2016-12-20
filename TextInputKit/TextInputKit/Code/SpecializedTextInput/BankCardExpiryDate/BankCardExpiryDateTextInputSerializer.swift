//
//  BankCardExpiryDateTextInputSerializer.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

final class BankCardExpiryDateTextInputSerializer : TextInputSerializer<DateComponents> {

    init(_ options: BankCardExpiryDateTextInputOptions) {
        self.options = options
    }


    override func string(for value: DateComponents) -> String {
        return "\(value.month) / \(value.year)"
    }

    override func value(for string: String) throws -> DateComponents {
        let components = string.components(separatedBy: "/")
        guard components.count == 2, let month = Int(components[0]), let year = Int(components[1]) else {
            throw BankCardExpiryDateTextInputError.incompleteTextInput
        }

        return DateComponents(year: year, month: month)
    }

    private let options: BankCardExpiryDateTextInputOptions

}
