//
//  TextInputSimulator+TextInputFormatBindable.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 05/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import TextInputKit

extension TextInputSimulator : TextInputFormatBindable {

    func bind<Value>(format: TextInputFormat<Value>) -> TextInputBinding<Value> {
        return Binding(format, self)
    }

}

private class Binding<Value: Equatable> : TextInputBinding<Value> {

    public override var value: Value? {
        get {
            return valueStore
        }
        set {
            valueStore = newValue

            if let textInput = boundTextInput {
                textInput.text = {
                    if let newValue = newValue {
                        return format.serializer.string(for: newValue)
                    }
                    return ""
                }()
            }
        }
    }

    init(
        _ format: TextInputFormat<Value>,
        _ textInput: TextInputSimulator) {

        self.boundTextInput = textInput

        super.init(format)

        textInput.text = ""
        textInput.delegate = self
    }

    public override func unbind() {
        if let textInput = boundTextInput {
            textInput.delegate = nil

            boundTextInput = nil
        }
    }

    fileprivate weak var boundTextInput: TextInputSimulator?

    fileprivate var valueStore: Value? = nil

}

extension Binding : TextInputSimulatorDelegate {

    func editingDidBegin() {
        // TODO: When event handling in bindings is ready, notify event.
    }

    func editingChanged() {
        if let textInput = boundTextInput {
            valueStore = try? format.serializer.value(for: textInput.text)
        }
    }

    func editingDidEnd() {
        // TODO: When event handling in bindings is ready, notify event.
    }

    func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult {

        return format.formatter.validate(
            editing: originalString,
            withSelection: originalSelectedRange,
            replacing: replacementString,
            at: editedRange)
    }

}
