//
//  TextInputFormatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

open class TextInputFormatter : TextInputFormatterType {

    open func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        abstractMethod()
    }

}
