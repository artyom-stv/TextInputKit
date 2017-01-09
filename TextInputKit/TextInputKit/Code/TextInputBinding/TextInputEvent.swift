//
//  TextInputEvent.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 23/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

public struct TextInputEditingState<Value: Equatable> {

    public var text: String
    public var selectedRange: Range<String.Index>
    public var value: Value?

}

public struct TextInputEditingChanges: OptionSet {

    public let rawValue: Int

    public static let text          = TextInputEditingChanges(rawValue: 1 << 0)
    public static let selectedRange = TextInputEditingChanges(rawValue: 1 << 1)
    public static let value         = TextInputEditingChanges(rawValue: 1 << 2)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}

public enum TextInputEvent<Value: Equatable> {

    case editingDidBegin

    case editingChanged(TextInputEditingState<Value>, TextInputEditingChanges)

    case editingDidEnd

}
