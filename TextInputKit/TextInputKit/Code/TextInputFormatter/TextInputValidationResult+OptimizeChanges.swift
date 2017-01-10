//
//  TextInputValidationResult+OptimizeChanges.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 10/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

public extension TextInputValidationResult {

    static func optimalValidationResult(
        forEditing originalString: String,
        replacing replacementString: String,
        at editedRange: Range<String.Index>,
        withSelection originalSelectedRange: Range<String.Index>,
        resulting resultingString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        let hasChangesAgainstOriginalInput: Bool = {
            return (originalSelectedRange != resultingSelectedRange)
                || (originalString != resultingString)
        }()

        if !hasChangesAgainstOriginalInput {
            return .rejected
        }

        let hasChangesAgainstProposedResult: Bool = {
            let proposedResultingString = originalString.replacingCharacters(in: editedRange, with: replacementString)
            if resultingString != proposedResultingString {
                return true
            }

            let proposedResultingSelectedRange: Range<String.Index> = {
                var index = (editedRange.lowerBound == originalString.startIndex)
                    ? proposedResultingString.startIndex
                    : proposedResultingString.index(after: originalString.index(before: editedRange.lowerBound))
                index = proposedResultingString.index(index, offsetBy: replacementString.characters.count)
                return index..<index
            }()
            return resultingSelectedRange != proposedResultingSelectedRange
        }()

        if !hasChangesAgainstProposedResult {
            return .accepted
        }

        return .changed(resultingString, selectedRange: resultingSelectedRange)
    }

}
