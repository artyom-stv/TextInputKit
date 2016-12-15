//
//  BankCardNumberTestDataSet.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 10/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import TextInputKit

struct BankCardNumberTestDataSet {

    struct SampleCardNumber {

        let digitsString: String
        let formattedString: String
        let cardBrand: BankCardBrand

        static let uatp: SampleCardNumber = .init(
            digitsString: "122000000000003",
            formattedString: "1220 00000 000003",
            cardBrand: .uatp)

        static let amex: SampleCardNumber = .init(
            digitsString: "378282246310005",
            formattedString: "3782 822463 10005",
            cardBrand: .amex)

        static let visa: SampleCardNumber = .init(
            digitsString: "4111111111111111",
            formattedString: "4111 1111 1111 1111",
            cardBrand: .visa)

        static let masterCard: SampleCardNumber = .init(
            digitsString: "5454545454545454",
            formattedString: "5454 5454 5454 5454",
            cardBrand: .masterCard)

    }

    static let cardNumbers: [SampleCardNumber] = [
        .uatp,
        .amex,
        .visa,
        .masterCard
    ]

}

func ==(lhs: BankCardNumberTestDataSet.SampleCardNumber, rhs: BankCardNumber) -> Bool {
    return (lhs.digitsString == rhs.digitsString) && (lhs.formattedString == rhs.formattedString) && (lhs.cardBrand == rhs.cardBrand)
}

func ==(lhs: BankCardNumber, rhs: BankCardNumberTestDataSet.SampleCardNumber) -> Bool {
    return rhs == lhs
}
