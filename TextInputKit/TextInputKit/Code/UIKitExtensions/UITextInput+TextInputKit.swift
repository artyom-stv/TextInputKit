//
//  UITextInput+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

extension UITextInput {

    var textInputKit_selectedUtf16IntRange: Range<Int>? {
        get {
            if let selectedTextRange = selectedTextRange {
                return Range<Int>(uncheckedBounds: (
                    lower: offset(from: beginningOfDocument, to: selectedTextRange.start),
                    upper: offset(from: beginningOfDocument, to: selectedTextRange.end)
                ))
            }
            return nil
        }
        set {
            selectedTextRange = {
                if let range = newValue {
                    guard
                        let start = position(from: beginningOfDocument, offset: range.lowerBound),
                        let end = position(from: beginningOfDocument, offset: range.upperBound)
                        else {
                            fatalError("New selected range is out of text bounds.")
                    }

                    return textRange(from: start, to: end)
                }
                return selectedTextRange
            }()
        }
    }
    
}

#endif
