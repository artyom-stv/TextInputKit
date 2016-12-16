//
//  BindingForNSTextFieldCell.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import Cocoa

final class BindingForNSTextFieldCell<Value> : TextInputBinding<Value> {

    public override var value: Value? {
        get {
            guard let representedObject = boundCell?.representedObject else {
                return nil
            }
            guard let objectValue = representedObject as? FormatterObjectValue<Value> else {
                fatalError("Unexpected NSTextFieldCell.representedObject type (expected: \(String(describing: FormatterObjectValue<Value>.self)), actual: \(String(describing: type(of: representedObject))))")
            }
            guard case let .value(value) = objectValue else {
                return nil
            }
            return value
        }
        set {
            boundCell?.representedObject = FormatterObjectValue.value(newValue)
        }
    }

    init(
        _ format: TextInputFormat<Value>,
        _ cell: NSTextFieldCell) {

        self.boundCell = cell

        super.init(format)

        cell.objectValue = nil
        cell.formatter = format.toFormatter()
    }

    public override func unbind() {
        if let cell = boundCell {
            cell.formatter = nil

            boundCell = nil
        }
    }

    private weak var boundCell: NSTextFieldCell?

}
