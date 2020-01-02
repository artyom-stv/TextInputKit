//
//  TextInputFormatterType+Map.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormatterType {

    typealias MapTransform = (String, Range<String.Index>) -> (String, Range<String.Index>)

    func map(_ transform: @escaping MapTransform) -> TextInputFormatter {
        return succeed(by: Map(transform))
    }

}

private final class Map: TextInputAccessoryFormatter {

    typealias Transform = TextInputFormatterType.MapTransform

    init(_ transform: @escaping Transform) {
        self.transform = transform
    }

    override func validate(
        editingResult editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        let (newEditedString, newSelectedRange) = transform(editedString, resultingSelectedRange)

        return (editedString == newEditedString && resultingSelectedRange == newSelectedRange)
            ? .accepted
            : .changed(newEditedString, selectedRange: newSelectedRange)
    }

    private let transform: Transform

}
