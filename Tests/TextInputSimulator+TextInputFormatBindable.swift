//
//  TextInputSimulator+TextInputFormatBindable.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 05/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation
@testable import TextInputKit

extension TextInputSimulator : TextInputFormatBindable {

    func bind<Value>(format: TextInputFormat<Value>) -> TextInputBinding<Value> {
        return Binding(format, self)
    }

}

private class Binding<Value: Equatable> : TextInputBinding<Value> {

    override var text: String {
        get {
            return withTextInput { textInput in
                return textInput.text
            }
        }
        set(newText) {
            return withTextInput { textInput in
                textInput.text = newText
            }
        }
    }

    override var selectedRange: Range<String.Index>? {
        get {
            return withTextInput { textInput in
                return textInput.selectedRange
            }
        }
        set(newSelectedRange) {
            return withTextInput { textInput in
                textInput.selectedRange = newSelectedRange
            }
        }
    }

    override var value: Value? {
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

    override var eventHandler: EventHandler? {
        get {
            return eventNotifier.eventHandler
        }
        set(newEventHandler) {
            eventNotifier.eventHandler = newEventHandler
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

    fileprivate let eventNotifier = TextInputEventNotifier<Value>()

    fileprivate var latestEditingState: TextInputEditingState<Value>?

    private func withTextInput<R>(_ closure: (TextInputSimulator) -> R) -> R {
        guard let textInput = boundTextInput else {
            Swift.fatalError("The `TextInputSimulator` was unbound or deallocated.")
        }
        return closure(textInput)
    }

}

extension Binding : TextInputSimulatorDelegate {

    func editingDidBegin() {
        latestEditingState = currentEditingState

        eventNotifier.on(.editingDidBegin)
    }

    func editingChanged() {
        if let textInput = boundTextInput {
            valueStore = try? format.serializer.value(for: textInput.text)
        }

        let newEditingState = currentEditingState
        eventNotifier.onEditingChanged(from: latestEditingState!, to: newEditingState)
        latestEditingState = newEditingState
    }

    func editingDidEnd() {
        latestEditingState = nil

        eventNotifier.on(.editingDidEnd)
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

    private var currentEditingState: TextInputEditingState<Value> {
        let textInput = boundTextInput!

        guard let selectedRange = textInput.selectedRange else {
            Swift.fatalError("The selected range in a `TextInputSimulator` should be non-nil while editing.")
        }

        return TextInputEditingState(
            text: textInput.text,
            selectedRange: selectedRange,
            value: valueStore)
    }

}
