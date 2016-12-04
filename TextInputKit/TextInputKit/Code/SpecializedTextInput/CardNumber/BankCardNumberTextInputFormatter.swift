//
//  BankCardNumberTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

final class BankCardNumberTextInputFormatter : TextInputFormatter {

    init(_ options: BankCardNumberTextInputOptions) {
        self.options = options
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        // TODO: Implement.
        return .accepted
    }

    private let options: BankCardNumberTextInputOptions

}
