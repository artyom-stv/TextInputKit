//
//  BindingForNSTextField.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(macOS)

import Foundation
import Cocoa

final class BindingForNSTextField<Value: Equatable> : TextInputBinding<Value> {

    // MARK: TextInputBinding<Value> Overrides

    override var text: String {
        get {
            return withTextField { textField in
                return textField.stringValue
            }
        }
        set(newText) {
            withTextField { textField in
                textField.stringValue = newText
            }
        }
    }

    override var selectedRange: Range<String.Index>? {
        get {
            return withTextField { textField in
                return textField.currentEditor()?.selectedIndexRange
            }
        }
        set(newSelectedRange) {
            withTextField { textField in
                guard let editor = textField.currentEditor() else {
                    fatalError("Can't set the selected range while the bound `NSTextField` isn't editing.")
                }

                editor.selectedIndexRange = newSelectedRange
            }
        }
    }

    override var value: Value? {
        get {
            return withTextField { textField in
                return payload.objectValue(in: textField).value
            }
        }
        set {
            withTextField { textField in
                let text: String
                if let newValue = newValue {
                    text = format.serializer.string(for: newValue)
                }
                else {
                    text = ""
                }

                textField.objectValue = FormatterObjectValue(
                    value: newValue,
                    text: text)
            }
        }
    }

    override var eventHandler: EventHandler? {
        get {
            return payload.eventNotifier.eventHandler
        }
        set(newEventHandler) {
            payload.eventNotifier.eventHandler = newEventHandler
        }
    }

    public override func unbind() {
        if let textField = payload.boundTextField {
            textField.formatter = nil
            textField.delegate = nil

            payload.boundTextField = nil
        }
    }

    // MARK: Initializers

    init(
        _ format: TextInputFormat<Value>,
        _ textField: NSTextField) {

        self.payload = Payload(format, textField)
        self.responder = Responder(payload)

        super.init(format)

        bind(textField)
    }

    // MARK: Private Properties

    private let payload: Payload<Value>

    private let responder: Responder<Value>

    // MARK: Private Methods

    private func bind(_ textField: NSTextField) {
        textField.objectValue = FormatterObjectValue<Value>()
        textField.formatter = {
            var options = FormatterOptions.default()
            options.tracksCurrentEditorSelection = true
            return format.toFormatter(options)
        }()
        textField.delegate = responder
    }

    func withTextField<R>(_ closure: (NSTextField) -> R) -> R {
        guard let textField = payload.boundTextField else {
            fatalError("The `NSTextField` was unbound or deallocated.")
        }
        return closure(textField)
    }

}

private class Payload<Value: Equatable> {

    let format: TextInputFormat<Value>

    weak var boundTextField: NSTextField?

    var eventNotifier = TextInputEventNotifier<Value>()

    init(_ format: TextInputFormat<Value>, _ boundTextField: NSTextField) {
        self.format = format
        self.boundTextField = boundTextField
    }

}

extension Payload {

    func objectValue(in textField: NSTextField) -> FormatterObjectValue<Value> {
        guard let untypedObjectValue = textField.objectValue else {
            fatalError("`textField.objectValue` shouldn't be nil.")
        }
        guard let objectValue = untypedObjectValue as? FormatterObjectValue<Value> else {
            fatalError("Unexpected `textField.objectValue` type (expected: \(String(describing: FormatterObjectValue<Value>.self)), actual: \(String(describing: type(of: untypedObjectValue))))")
        }
        return objectValue
    }

}

private final class Responder<Value: Equatable> : NSObject, NSTextFieldDelegate {

    // MARK: Initializers

    init(_ payload: Payload<Value>) {
        self.payload = payload
    }

    // MARK: Control Events

    func controlTextDidBeginEditing(_ notification: Notification) {
        let textField = payload.boundTextField!

        assert(textField.currentEditor()! === notification.userInfo!["NSFieldEditor"] as! NSText)

        latestEditingState = currentEditingState(of: textField)

        payload.eventNotifier.on(.editingDidBegin)
    }

    func controlTextDidEndEditing(_ notification: Notification) {
        latestEditingState = nil

        payload.eventNotifier.on(.editingDidEnd)
    }

    func controlTextDidChange(_ notification: Notification) {
        let textField = payload.boundTextField!

        assert(textField.currentEditor()! === notification.userInfo!["NSFieldEditor"] as! NSText)

        let newEditingState = currentEditingState(of: textField)
        payload.eventNotifier.onEditingChanged(from: latestEditingState!, to: newEditingState)
        latestEditingState = newEditingState
    }

    // MARK: Private Properties

    private var payload: Payload<Value>

    private var latestEditingState: TextInputEditingState<Value>?

    // MARK: Private Methods

    @nonobjc
    private func currentEditingState(of textField: NSTextField) -> TextInputEditingState<Value> {
        guard let selectedRange = textField.currentEditor()!.selectedIndexRange else {
            fatalError("The selected range in a `UITextField` should be non-nil while editing.")
        }

        let objectValue = payload.objectValue(in: textField)

        return TextInputEditingState(
            text: objectValue.text,
            selectedRange: selectedRange,
            value: objectValue.value)
    }

}

#endif
