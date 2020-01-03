//
//  UITextField+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(iOS) || os(tvOS)

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
                        fatalError("Cannot set the selected range of a `UITextField` while the text field isn't editing.")
                    }

                    return range.sameRange(in: text.utf16)!.sameIntRange(in: text.utf16)
                }
                return nil
            }()
        }
    }

}

extension UITextField: TextInputFormatBindable {

    public func bind<Value>(format: TextInputFormat<Value>) -> TextInputBinding<Value> {
        return BindingForUITextField<Value>(format, self)
    }

}

#endif
