//
//  DriverOfUITextField.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import UIKit

final class DriverOfUITextField<Value> : TextInputDriver<Value> {

    public override var value: Value? {
        get {
            return valueBox.value
        }
        set {
            valueBox.value = newValue

            if let textField = boundTextField {
                textField.text = {
                    if let newValue = newValue {
                        return format.serializer.string(for: newValue)
                    }
                    return nil
                }()
            }
        }
    }

    init(
        _ format: TextInputFormat<Value>,
        _ textField: UITextField) {

        self.boundTextField = textField
        self.valueBox = MutableBox<Value?>(nil)
        self.textFieldDelegate = TextFieldDelegate(format, valueBox: valueBox)

        super.init(format)

        textField.delegate = textFieldDelegate
    }

    public override func unbind() {
        if let textField = boundTextField {
            textField.delegate = nil

            boundTextField = nil
        }
    }

    private weak var boundTextField: UITextField?

    private let valueBox: MutableBox<Value?>

    private let textFieldDelegate: TextFieldDelegate<Value>

}

private final class TextFieldDelegate<Value> : NSObject, UITextFieldDelegate {

    init(_ format: TextInputFormat<Value>, valueBox: MutableBox<Value?>) {
        self.format = format
        self.valueBox = valueBox
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn editedNSRange: NSRange,
        replacementString: String) -> Bool {

        let originalString = textField.text ?? ""

        let originalSelectedRange = textField.textInputKit_selectedRange!

        let editedRange: Range<String.Index> = editedNSRange.toRange()!
            .sameRange(in: originalString.utf16)
            .sameRange(in: originalString)

        let validationResult = format.formatter.validate(
            editing: originalString,
            withSelection: originalSelectedRange,
            replacing: replacementString,
            at: editedRange)

        switch validationResult {
        case .accepted:
            let editedString = originalString.replacingCharacters(in: editedRange, with: replacementString)

            setValue(for: editedString)

            return true

        case .changed(let newEditedString, let newSelectedRange):
            textField.text = newEditedString
            textField.textInputKit_selectedRange = newSelectedRange

            setValue(for: newEditedString)

            return false
            
        case .rejected:
            return false
        }
    }
    
    private let format: TextInputFormat<Value>
    
    private var valueBox: MutableBox<Value?>

    private func setValue(for string: String) {
        valueBox.value = try? format.serializer.value(for: string)
    }
    
}
