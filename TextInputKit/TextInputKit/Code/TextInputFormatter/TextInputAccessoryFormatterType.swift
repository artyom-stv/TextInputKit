//
//  TextInputAccessoryFormatterType.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 26/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public protocol TextInputAccessoryFormatterType : class {

    /// Usage:
    /// formatter.validate(editingResult: newText, withSelection: newSelectedRange)
    func validate(
        editingResult editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult

}
