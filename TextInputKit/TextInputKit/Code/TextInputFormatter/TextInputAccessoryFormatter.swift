//
//  TextInputAccessoryFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 26/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

open class TextInputAccessoryFormatter: TextInputAccessoryFormatterType {

    public func validate(
        editingResult editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        abstractMethod()
    }

}
