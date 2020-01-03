//
//  BindingForUITextField.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

final class BindingForUITextField<Value: Equatable> : TextInputBinding<Value> {

    // MARK: TextInputBinding<Value> Overrides

    override var text: String {
        get {
            return withTextField { textField in
                return textField.text ?? ""
            }
        }
        set(newText) {
            withTextField { textField in
                textField.text = newText
            }

            payload.value = try? payload.format.serializer.value(for: newText)
        }
    }

    override var selectedRange: Range<String.Index>? {
        get {
            return withTextField { textField in
                return textField.selectedRange
            }
        }
        set(newSelectedRange) {
            withTextField { textField in
                textField.selectedRange = newSelectedRange
            }
        }
    }

    override var value: Value? {
        get {
            return payload.value
        }
        set {
            payload.value = newValue

            withTextField { textField in
                textField.text = {
                    if let newValue = newValue {
                        return format.serializer.string(for: newValue)
                    }
                    return nil
                }()
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

    override func unbind() {
        if let textField = boundTextField {
            textField.delegate = nil
            textField.removeTarget(
                responder,
                action: nil,
                for: .editingChanged)

            boundTextField = nil
        }
    }

    // MARK: Initializers

    init(
        _ format: TextInputFormat<Value>,
        _ textField: UITextField) {

        self.boundTextField = textField
        self.payload = Payload(format)
        self.responder = Responder(payload)

        super.init(format)

        bind(textField)
    }

    // MARK: Private Properties

    private weak var boundTextField: UITextField?

    private let payload: Payload<Value>

    private let responder: Responder<Value>

    // MARK: Private Methods

    private func bind(_ textField: UITextField) {
        textField.text = nil
        textField.delegate = responder
        textField.addTarget(
            responder,
            action: #selector(Responder<Value>.actionForEditingChanged(_:)),
            for: .editingChanged)
    }

    private func withTextField<R>(_ closure: (UITextField) -> R) -> R {
        guard let textField = boundTextField else {
            fatalError("The `UITextField` was unbound or deallocated.")
        }
        return closure(textField)
    }

}

private class Payload<Value: Equatable> {

    let format: TextInputFormat<Value>

    var value: Value? = nil

    var eventNotifier = TextInputEventNotifier<Value>()

    init(_ format: TextInputFormat<Value>) {
        self.format = format
    }

}

private final class Responder<Value: Equatable> : NSObject, UITextFieldDelegate {

    // MARK: Initializers

    init(_ payload: Payload<Value>) {
        self.payload = payload
    }

    // MARK: UITextFieldDelegate Protocol Implementation

    func textFieldDidBeginEditing(_ textField: UITextField) {
        payload.eventNotifier.on(.editingDidBegin)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        payload.eventNotifier.on(.editingDidEnd)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn editedNSRange: NSRange,
        replacementString: String) -> Bool {

        let originalState = currentEditingState(of: textField)

        let editedRange: Range<String.Index> = Range(editedNSRange)!
            .sameRange(in: originalState.text.utf16)
            .sameRange(in: originalState.text)

        let validationResult = payload.format.formatter.validate(
            editing: originalState.text,
            withSelection: originalState.selectedRange,
            replacing: replacementString,
            at: editedRange)

        switch validationResult {
        case .accepted:
            pendingEditingChangedEventOriginalState = originalState

            // The work is continued in `actionForEditingChanged(_:)`

            return true

        case .changed(let newText, let newSelectedRange):
            textField.text = newText
            textField.selectedRange = newSelectedRange

            payload.value = value(for: newText)

            let newState = TextInputEditingState(
                text: newText,
                selectedRange: newSelectedRange,
                value: payload.value)
            payload.eventNotifier.onEditingChanged(from: originalState, to: newState)

            return false
            
        case .rejected:
            return false
        }
    }

    // MARK: Event Actions

    /// The action for `UIControlEvents.editingChanged` event of a `UITextField`.
    ///
    /// - Parameter textField: The `UITextField`.
    @objc
    func actionForEditingChanged(_ textField: UITextField) {
        guard let originalState = pendingEditingChangedEventOriginalState else {
            fatalError("`\(#function)` should be called after `textField(_:shouldChangeCharactersIn:replacementString:)` returns `true`. In that case, `pendingEditingChangedEventOriginalState` should be non-nil.")
        }

        payload.value = value(for: textField.text ?? "")

        let newState = currentEditingState(of: textField)
        payload.eventNotifier.onEditingChanged(from: originalState, to: newState)

        pendingEditingChangedEventOriginalState = nil
    }

    // MARK: Private Properties

    private var payload: Payload<Value>

    /// Stores the editing state between returning `true` from
    /// `textField(_:shouldChangeCharactersIn:replacementString:)` and receiving `UIControlEvents.editingChanged` event.
    private var pendingEditingChangedEventOriginalState: TextInputEditingState<Value>?

    // MARK: Private Methods

    @nonobjc
    private func currentEditingState(of textField: UITextField) -> TextInputEditingState<Value> {
        assert(textField.isEditing)

        guard let selectedRange = textField.selectedRange else {
            fatalError("The selected range in a `UITextField` should be non-nil while editing.")
        }

        return TextInputEditingState(
            text: textField.text ?? "",
            selectedRange: selectedRange,
            value: payload.value)
    }

    @nonobjc
    private func value(for string: String) -> Value? {
        return try? payload.format.serializer.value(for: string)
    }

}

#endif
