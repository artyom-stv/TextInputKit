//
//  UITextField+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    var textInputKit_selectedRange: Range<String.Index>? {
        get {
            if let utf16IntRange = textInputKit_selectedUtf16IntRange {
                // self.text is not nil when self.selectedTextRange is not nil
                let text = self.text!
                return utf16IntRange.sameRange(in: text.utf16).sameRange(in: text)
            }
            return nil
        }
        set {
            textInputKit_selectedUtf16IntRange = {
                if let range = newValue {
                    guard let text = self.text else {
                        // TODO: Write message.
                        fatalError("")
                    }

                    return range.sameRange(in: text.utf16).sameIntRange(in: text.utf16)
                }
                return nil
            }()
        }
    }

}
