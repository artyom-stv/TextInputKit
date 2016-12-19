//
//  BindingForNSTextField.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import Cocoa

final class BindingForNSTextField<Value> : TextInputBinding<Value> {

    public override var value: Value? {
        get {
            guard let untypedObjectValue = boundTextField?.objectValue else {
                return nil
            }
            guard let objectValue = untypedObjectValue as? FormatterObjectValue<Value> else {
                fatalError("Unexpected NSTextField.objectValue type (expected: \(String(describing: FormatterObjectValue<Value>.self)), actual: \(String(describing: type(of: untypedObjectValue))))")
            }
            guard case let .value(value) = objectValue else {
                return nil
            }
            return value
        }
        set {
            boundTextField?.objectValue = FormatterObjectValue.value(newValue)
        }
    }

    init(
        _ format: TextInputFormat<Value>,
        _ textField: NSTextField) {

        self.boundTextField = textField

        super.init(format)

        textField.objectValue = nil
        textField.formatter = {
            var options = FormatterOptions.options()
            options.tracksCurrentEditorSelection = true
            return format.toFormatter(options)
        }()
    }

    public override func unbind() {
        if let textField = boundTextField {
            textField.formatter = nil
            
            boundTextField = nil
        }
    }
    
    private weak var boundTextField: NSTextField?
    
}
