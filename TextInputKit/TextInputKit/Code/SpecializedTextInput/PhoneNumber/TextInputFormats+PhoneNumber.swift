//
//  TextInputFormats+PhoneNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import PhoneNumberKit

public extension TextInputFormats {

    static func phoneNumber(_ options: PhoneNumberTextInputOptions = .options()) throws -> TextInputFormat<PhoneNumber> {
        // TODO: Remove when phone number text input formatting is supported.
        print("TextInputFormats.\(#function) isn't supported yet.")

        let isPhoneNumberKitFrameworkLoaded = (NSClassFromString("PhoneNumberKit.PhoneNumberKit") != nil)
        if !isPhoneNumberKitFrameworkLoaded {
            throw TextInputKitError.missingFramework("PhoneNumberKit")
        }

        let serializer = TextInputSerializer.identical.map(
            direct: {
                return PhoneNumber(formattedString: $0, number: $0)
        },
            reverse: {
                return $0.formattedString
        })

        let formatter = PhoneNumberTextInputFormatter(options)

        return TextInputFormat<PhoneNumber>.from(serializer, formatter)
    }

}
