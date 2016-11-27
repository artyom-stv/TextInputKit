//
//  TextInputFormatterType.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 21/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public enum TextInputValidationResult {

    case accepted

    case changed(String, selectedRange: Range<String.Index>)

    case rejected
    
}

public protocol TextInputFormatterType : class {

    /// Usage:
    /// formatter.validate(editing: oldText, at: editedRange, withSelection: oldSelectedRange, resulting: newText)
    func validate(
        editing originalString: String,
        at editedRange: Range<String.Index>,
        withSelection originalSelectedRange: Range<String.Index>,
        resulting editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult

}
