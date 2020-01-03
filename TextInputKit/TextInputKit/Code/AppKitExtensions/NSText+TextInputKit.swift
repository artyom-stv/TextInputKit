//
//  NSText+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 19/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(macOS)

import AppKit

extension NSText {

    var selectedUTF16IntRange: Range<Int>? {
        get {
            return Range(selectedRange)
        }
        set {
            selectedRange = {
                if let range = newValue {
                    return NSRange(range)
                }
                // TODO: Verify.
                return NSRange(location: NSNotFound, length: 0)
            }()
        }
    }

    var selectedIndexRange: Range<String.Index>? {
        get {
            if let utf16IntRange = selectedUTF16IntRange {
                let string = self.string
                return utf16IntRange.sameRange(in: string.utf16).sameRange(in: string)
            }
            return nil
        }
        set {
            selectedUTF16IntRange = {
                if let range = newValue {
                    let string = self.string
                    return range.sameRange(in: string.utf16)!.sameIntRange(in: string.utf16)
                }
                return nil
            }()
        }
    }

}

#endif
