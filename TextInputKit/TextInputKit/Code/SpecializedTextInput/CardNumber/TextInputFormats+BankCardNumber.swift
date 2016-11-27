//
//  TextInputFormats+BankCardNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormats {

    static func bankCardNumber(_ options: BankCardNumberTextInputOptions) -> TextInputFormat<BankCardNumber> {
        // TODO: Remove when phone number text input formatting is supported.
        print("TextInputFormats.\(#function) isn't supported yet.")

        let serializer = TextInputSerializer.identical.map(
            direct: {
                return BankCardNumber(formattedString: $0, number: $0)
        },
            reverse: {
                return $0.formattedString
        })

        let formatter = BankCardNumberTextInputFormatter(options)

        return TextInputFormat<String>.from(serializer, formatter)
    }
    
}
