//
//  TextInputFormatter+Plain.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormatterType {

    static var plain: TextInputFormatter {
        return PlainTextInputFormatter()
    }

}

private final class PlainTextInputFormatter : TextInputFormatter {

    override func validate(
        editing originalString: String,
        at editedRange: Range<String.Index>,
        withSelection originalSelectedRange: Range<String.Index>,
        resulting editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        return .accepted
    }

}
