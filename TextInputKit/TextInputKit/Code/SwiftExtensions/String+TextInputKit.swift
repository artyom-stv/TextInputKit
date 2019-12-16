//
//  String+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 04/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

extension String.UnicodeScalarView {

    public func replacingSubrangeAndReturningNewSubrange(
        _ range: Range<String.UnicodeScalarView.Index>,
        with replacementStringView: String.UnicodeScalarView
        ) -> (String.UnicodeScalarView, Range<String.UnicodeScalarView.Index>)
    {
        var newView = self
        newView.replaceSubrange(range, with: replacementStringView)

        let newLowerBound = (range.lowerBound == self.startIndex)
            ? newView.startIndex
            : newView.index(after: self.index(before: range.lowerBound))

        let newRange = newLowerBound ..< newView.index(newLowerBound, offsetBy: replacementStringView.count)

        return (newView, newRange)
    }

    public func asSubstringView() -> Substring.UnicodeScalarView {
        return suffix(from: startIndex)
    }

}
