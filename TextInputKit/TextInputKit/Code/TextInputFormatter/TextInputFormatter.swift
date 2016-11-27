//
//  TextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

open class TextInputFormatter : TextInputFormatterType {

    public func validate(
        editing originalString: String,
        at editedRange: Range<String.Index>,
        withSelection originalSelectedRange: Range<String.Index>,
        resulting editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        abstractMethod()
    }

}
