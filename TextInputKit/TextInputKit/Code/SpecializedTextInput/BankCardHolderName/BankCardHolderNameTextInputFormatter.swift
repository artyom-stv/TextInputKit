//
//  BankCardHolderNameTextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

final class BankCardHolderNameTextInputFormatter : TextInputFormatter {

    init(_ options: BankCardHolderNameTextInputOptions) {
        self.options = options
    }

    override func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        return .accepted
    }

    private let options: BankCardHolderNameTextInputOptions

}
