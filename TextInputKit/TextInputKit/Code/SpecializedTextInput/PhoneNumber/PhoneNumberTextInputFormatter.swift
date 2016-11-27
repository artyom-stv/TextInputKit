//
//  PhoneNumberTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 27/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

class PhoneNumberTextInputFormatter : TextInputFormatter {

    init(_ options: PhoneNumberTextInputOptions) {
        self.options = options
    }

    override func validate(
        editing originalString: String,
        at editedRange: Range<String.Index>,
        withSelection originalSelectedRange: Range<String.Index>,
        resulting editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        // TODO: Implement.
        return .accepted
    }

    private let options: PhoneNumberTextInputOptions
    
}
