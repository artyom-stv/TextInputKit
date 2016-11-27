//
//  TextInputFormatterType+Proceed.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

// supplementary
// secondary — coming after, less important than, or resulting from someone or something else that is primary
// accessory — contributing to or aiding an activity or process in a minor way; subsidiary or supplementary.
public extension TextInputFormatterType {

    func succeed(by successiveFormatter: TextInputAccessoryFormatter) -> TextInputFormatter {
        return Succeed(source: self, successive: successiveFormatter)
    }

}

private final class Succeed : TextInputFormatter {

    init(
        source sourceFormatter: TextInputFormatterType,
        successive successiveFormatter: TextInputAccessoryFormatter) {

        self.sourceFormatter = sourceFormatter
        self.successiveFormatter = successiveFormatter
    }

    override func validate(
        editing originalString: String,
        at editedRange: Range<String.Index>,
        withSelection originalSelectedRange: Range<String.Index>,
        resulting editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        let sourceValidationResult = sourceFormatter.validate(
            editing: originalString,
            at: editedRange,
            withSelection:  originalSelectedRange,
            resulting: editedString,
            withSelection: resultingSelectedRange)

        switch sourceValidationResult {
        case .accepted:
            return successiveFormatter.validate(
                editingResult: editedString,
                withSelection: resultingSelectedRange)

        case .changed(let newEditedString, let newSelectedRange):
            return successiveFormatter.validate(
                editingResult: newEditedString,
                withSelection: newSelectedRange)

        case .rejected:
            return .rejected
        }
    }

    private let sourceFormatter: TextInputFormatterType
    
    private let successiveFormatter: TextInputAccessoryFormatter
    
}
