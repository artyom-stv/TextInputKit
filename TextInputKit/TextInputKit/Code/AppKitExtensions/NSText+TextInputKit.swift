//
//  NSText+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 19/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import AppKit

extension NSText {

    var textInputKit_selectedUtf16IntRange: Range<Int>? {
        get {
            return self.selectedRange.toRange()
        }
        set {
            self.selectedRange = {
                if let range = newValue {
                    return NSRange(range)
                }
                // TODO: Verify.
                return NSRange(location: NSNotFound, length: 0)
            }()
        }
    }

    var textInputKit_selectedRange: Range<String.Index>? {
        get {
            if let utf16IntRange = textInputKit_selectedUtf16IntRange {
                // self.string is not nil when self.selectedRange is not { NSNotFound, 0 }
                let string = self.string!
                return utf16IntRange.sameRange(in: string.utf16).sameRange(in: string)
            }
            return nil
        }
        set {
            textInputKit_selectedUtf16IntRange = {
                if let range = newValue {
                    guard let string = self.string else {
                        // TODO: Write message.
                        fatalError("")
                    }

                    return range.sameRange(in: string.utf16).sameIntRange(in: string.utf16)
                }
                return nil
            }()
        }
    }

}
