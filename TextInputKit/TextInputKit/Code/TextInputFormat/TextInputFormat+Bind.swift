//
//  TextInputFormat+Bind.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension TextInputFormat {

    #if os(macOS)

    func bind(to textField: NSTextField) -> TextInputDriver<Value> {
        return DriverOfNSTextField<Value>(self, textField)
    }

    func bind(to cell: NSTextFieldCell) -> TextInputDriver<Value> {
        return DriverOfNSTextFieldCell<Value>(self, cell)
    }

    #else

    func bind(to textField: UITextField) -> TextInputDriver<Value> {
        return DriverOfUITextField<Value>(self, textField)
    }

    #endif

}
