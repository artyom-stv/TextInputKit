//
//  BankCardExpiryDateTextInputSerializer.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

final class BankCardExpiryDateTextInputSerializer: TextInputSerializer<BankCardExpiryDate> {

    init(_ options: BankCardExpiryDateTextInputOptions) {
        self.options = options
    }

    override func string(for value: BankCardExpiryDate) -> String {
        let lastTwoDigitsOfYear = value.year % 100
        return "\(String(format: "%02d", value.month))/\(lastTwoDigitsOfYear)"
    }

    override func value(for string: String) throws -> BankCardExpiryDate {
        let stringComponents = try self.stringComponents(from: string)

        let intComponents = self.intComponents(from: stringComponents)

        do {
            return try BankCardExpiryDate(
                month: intComponents.month,
                lastTwoDigitsOfYear: intComponents.lastTwoDigitsOfYear)
        } catch {
            throw BankCardExpiryDateTextInputError.invalidMonth
        }
    }

    private let options: BankCardExpiryDateTextInputOptions

}

private extension BankCardExpiryDateTextInputSerializer {

    typealias ParsedStringComponents = (month: String, lastTwoDigitsOfYear: String)

    typealias ParsedIntComponents = (month: Int, lastTwoDigitsOfYear: Int)

    func stringComponents(from string: String) throws -> ParsedStringComponents {
        let components: [String] = string.components(separatedBy: StringUtils.slashCharacters)

        guard components.count <= 2 else {
            fatalError("`BankCardExpiryDateTextInputFormatter` shouldn't have formed a string with more than one 'slash' character.")
        }

        guard components.count == 2 else {
            throw BankCardExpiryDateTextInputError.incompleteInput
        }

        // Currently, `BankCardExpiryDateTextInputSerializer` supports only bank card expiry dates with two digits
        // in a year component, e.g. "01/17".
        // In future, we might support four-digit year components, e.g. "01/2017".
        let parsedComponents = (month: components[0], lastTwoDigitsOfYear: components[1])

        // A month component can be one character long to accept text input like "1/17".
        guard (1...2).contains(parsedComponents.month.unicodeScalars.count) else {
            throw BankCardExpiryDateTextInputError.incompleteInput
        }

        guard parsedComponents.lastTwoDigitsOfYear.unicodeScalars.count == 2 else {
            throw BankCardExpiryDateTextInputError.incompleteInput
        }

        return parsedComponents
    }

    func intComponents(from stringComponents: ParsedStringComponents) -> ParsedIntComponents {
        guard
            let monthComponent = Int(stringComponents.month),
            let yearComponent = Int(stringComponents.lastTwoDigitsOfYear)
            else {
                fatalError("`BankCardExpiryDateTextInputFormatter` should have formed a string only with digit characters in date components.")
        }

        return (month: monthComponent, lastTwoDigitsOfYear: yearComponent)
    }

}
