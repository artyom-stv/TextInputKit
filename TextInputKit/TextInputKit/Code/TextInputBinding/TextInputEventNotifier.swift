//
//  TextInputEventNotifier.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 09/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

class TextInputEventNotifier<Value: Equatable> {

    typealias EventHandler = (TextInputEvent<Value>) -> ()

    var eventHandler: EventHandler? = nil

    func on(_ event: TextInputEvent<Value>) {
        eventHandler?(event)
    }

    func onEditingChanged(from oldState: TextInputEditingState<Value>, to newState: TextInputEditingState<Value>) {
        let changes: TextInputEditingChanges = {
            var changes: TextInputEditingChanges = []
            if oldState.text != newState.text {
                changes.formUnion(.text)
            }
            if oldState.selectedRange != newState.selectedRange {
                changes.formUnion(.selectedRange)
            }
            if oldState.value != newState.value {
                changes.formUnion(.value)
            }
            return changes
        }()

        on(.editingChanged(newState, changes))
    }

}
