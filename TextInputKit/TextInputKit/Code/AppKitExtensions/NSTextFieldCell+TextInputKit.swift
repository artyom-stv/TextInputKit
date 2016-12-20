//
//  NSTextFieldCell+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import AppKit

extension NSTextFieldCell : TextInputFormatBindable {

    public func bind<Value>(format: TextInputFormat<Value>) -> TextInputBinding<Value> {
        return BindingForNSTextFieldCell<Value>(format, self)
    }

}
