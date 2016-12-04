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
        _ bounds: Range<String.UnicodeScalarView.Index>,
        with newElements: String.UnicodeScalarView
        ) -> (String.UnicodeScalarView, Range<String.UnicodeScalarView.Index>)
    {
        var newView = self
        newView.replaceSubrange(bounds, with: newElements)

        let newBoundsLowerBound = (bounds.lowerBound == self.startIndex)
            ? newView.startIndex
            : newView.index(after: self.index(before: bounds.lowerBound))

        let newBounds = newBoundsLowerBound ..< newView.index(newBoundsLowerBound, offsetBy: newElements.count)

        return (newView, newBounds)
    }

}
