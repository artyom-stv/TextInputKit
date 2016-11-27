//
//  DriverOfNSTextFieldCell.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import Cocoa

final class DriverOfNSTextFieldCell<Value> : TextInputDriver<Value> {

    public override var value: Value? {
        get {
            guard let representedObject = boundCell?.representedObject else {
                return nil
            }
            guard let value = representedObject as? Value else {
                fatalError("Unexpected NSTextFieldCell.representedObject type (expected: \(String(describing: Value.self)), actual: \(String(describing: type(of: representedObject))))")
            }
            return value
        }
        set {
            boundCell?.representedObject = newValue as Any
        }
    }

    init(
        _ format: TextInputFormat<Value>,
        _ cell: NSTextFieldCell) {

        self.boundCell = cell

        super.init(format)

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
