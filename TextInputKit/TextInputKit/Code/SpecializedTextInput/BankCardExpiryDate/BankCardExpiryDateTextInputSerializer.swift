//
//  BankCardExpiryDateTextInputSerializer.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

final class BankCardExpiryDateTextInputSerializer : TextInputSerializer<BankCardExpiryDate> {

    init(_ options: BankCardExpiryDateTextInputOptions) {
        self.options = options
    }

    override func string(for value: BankCardExpiryDate) -> String {
        let lastTwoDigitsOfYear = value.year % 100
        return "\(value.month) / \(lastTwoDigitsOfYear)"
    }

    override func value(for string: String) throws -> BankCardExpiryDate {
        let components = string.components(separatedBy: StringUtils.slashCharacters)

        guard components.count == 2 else {
            fatalError()
        }

        let monthComponent = components[0]
        let yearComponent = components[1]

        guard (1...2).contains(monthComponent.unicodeScalars.count), yearComponent.unicodeScalars.count == 2 else {
            throw BankCardExpiryDateTextInputError.incompleteTextInput
        }

        guard let month = Int(monthComponent), let lastTwoDigitsOfYear = Int(yearComponent) else {
            fatalError()
        }

        return try BankCardExpiryDate(month: month, lastTwoDigitsOfYear: lastTwoDigitsOfYear)
    }

    private let options: BankCardExpiryDateTextInputOptions

}
