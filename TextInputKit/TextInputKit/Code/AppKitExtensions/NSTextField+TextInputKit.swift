//
//  NSTextField+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(macOS)

import AppKit

extension NSTextField: TextInputFormatBindable {

    public func bind<Value>(format: TextInputFormat<Value>) -> TextInputBinding<Value> {
        return BindingForNSTextField<Value>(format, self)
    }
    
}

#endif
