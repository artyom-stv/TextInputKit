//
//  TextInputFormatterType+Filter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormatterType {

    typealias FilterPredicate = (String) -> Bool

    func filter(_ predicate: @escaping FilterPredicate) -> TextInputFormatter {
        return succeed(by: Filter(predicate))
    }

}

private final class Filter: TextInputAccessoryFormatter {

    typealias Predicate = TextInputFormatterType.FilterPredicate

    init(_ predicate: @escaping Predicate) {
        self.predicate = predicate
    }

    override func validate(
        editingResult editedString: String,
        withSelection resultingSelectedRange: Range<String.Index>) -> TextInputValidationResult {

        return predicate(editedString)
            ? .accepted
            : .rejected
    }

    private let predicate: Predicate

}
