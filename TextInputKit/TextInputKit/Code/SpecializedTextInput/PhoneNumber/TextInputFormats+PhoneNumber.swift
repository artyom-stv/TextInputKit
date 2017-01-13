//
//  TextInputFormats+PhoneNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import PhoneNumberKit

public extension TextInputFormats {

    static func phoneNumber(_ options: PhoneNumberTextInputOptions = .options()) throws -> TextInputFormat<PhoneNumber> {
        try PhoneNumberKit.checkThatFrameworkIsLoaded()

        let cachedPhoneNumberKit = PhoneNumberKit.cached

        let serializer = TextInputSerializer.identical.map(
            direct: { text -> PhoneNumber in
                do {
                    let phoneNumberKit = cachedPhoneNumberKit.instance
                    return PhoneNumber(try phoneNumberKit.parse(text))
                } catch let error as PhoneNumberError {
                    throw PhoneNumberTextInputError.from(error)
                }
        },
            reverse: { phoneNumber -> String in
                let phoneNumberKit = cachedPhoneNumberKit.instance
                return phoneNumberKit.format(phoneNumber.pnkPhoneNumber, toType: options.format.pnkFormat)
        })

        let formatter = PhoneNumberTextInputFormatter(options, cachedPhoneNumberKit)

        return TextInputFormat<PhoneNumber>.from(serializer, formatter)
    }

}

private extension PhoneNumberFormat {

    var pnkFormat: PNKPhoneNumberFormat {
        switch self {
        case .e164:
            return .e164
        case .international:
            return .international
        }
    }

}
