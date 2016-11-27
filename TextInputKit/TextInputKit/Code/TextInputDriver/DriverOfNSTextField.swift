//
//  DriverOfNSTextField.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import Cocoa

final class DriverOfNSTextField<Value> : TextInputDriver<Value> {

    public override var value: Value? {
        get {
            guard let objectValue = boundTextField?.objectValue else {
                return nil
            }
            guard let value = objectValue as? Value else {
                fatalError("Unexpected NSTextField.objectValue type (expected: \(String(describing: Value.self)), actual: \(String(describing: type(of: objectValue))))")
            }
            return value
        }
        set {
            boundTextField?.objectValue = newValue as Any
        }
    }

    init(
        _ format: TextInputFormat<Value>,
        _ textField: NSTextField) {

        self.boundTextField = textField

        super.init(format)

        textField.formatter = format.toFormatter()
    }

    public override func unbind() {
        if let textField = boundTextField {
            textField.formatter = nil
            
            boundTextField = nil
        }
    }
    
    private weak var boundTextField: NSTextField?
    
}
