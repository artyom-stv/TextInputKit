//
//  BankCardNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct BankCardNumber {

    public let formattedString: String

    public let number: String

    init(formattedString: String, number: String) {
        self.formattedString = formattedString
        self.number = number
    }

    public init(number: String) {
        guard number.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            fatalError("Bank card number should contain only decimal digits.")
        }

        self.formattedString = type(of: self).formattedString(forNumber: number)
        self.number = number
    }

}

private extension BankCardNumber {

    static func formattedString(forNumber number: String) -> String {
        // TODO: Implement
        return number
    }

}
