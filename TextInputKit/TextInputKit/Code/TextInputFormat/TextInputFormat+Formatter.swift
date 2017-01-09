//
//  TextInputFormat+Formatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit
#endif

public struct FormatterOptions {

    #if os(macOS)
    /// On macOS, the `tracksCurrentEditorSelection` option enables a better text input formatting quality for a `Formatter`
    /// being binded to an `NSTextField` or an `NSTextFieldCell`.
    /// (the same quality as it is provided by `TextInputFormat.bind(to:)` on iOS by default).
    ///
    /// On iOS and tvOS, a `Formatter` isn't used to format text input in a `UITextField`.
    /// On macOS, to format textinput in an `NSTextField` or an `NSTextFieldCell`, a `Formatter` is created.
    /// `Formatter` API doesn't allow us to distinguish deleting a selected character from pressing "Backspace"/"Delete" key
    /// without any selection. For example, it doesn't allow to distinguish the following cases for "1234 5678":
    /// - pressing a "Backspace" key when the cursor is standing before the character "5";
    /// - pressing a "Backspace" key when the character " " is selected.
    ///
    /// If the `tracksCurrentEditorSelection` option is `true`, then a `Formatter` created by `TextInputFormat.toFormatter(_:)`
    /// finds the current editor (an instance of `NSTextView`) and extracts the `selectedRange` from it.
    var tracksCurrentEditorSelection: Bool = false
    #endif

    static func options() -> FormatterOptions {
        return .init()
    }

}

extension TextInputFormat {

    /// Creates a `Formatter` with the object type `FormatterObjectValue<Value>`.
    ///
    /// The `FormatterObjectValue<Value>` is used to wrap a `Value` if present, or a string if no value is deserizlied from that string.
    /// The reason to use a `FormatterObjectValue<Value>` wrapper is the following `Formatter` and `NSTextField` standard behavior:
    /// - If we return `false` from the `getObjectValue(_:for:errorDescription:)` method then the `""` value is set to the text field.
    /// - If we set the `objectPtr` to `nil` and return `true` from the `getObjectValue(_:for:errorDescription:)` method then the text in the text input is reset.
    /// Both variants conflict with the desired behavior of the corresponding `TextInputBinding`. So, we have to set the `objectPtr` to a non-nil value and return `true` from the `getObjectValue(_:for:errorDescription:)` method, even when there is no `Value` representing the text in the text input.
    ///
    /// - Returns: The created `Formatter`.
    public func toFormatter(_ options: FormatterOptions = .options()) -> Formatter {
        return FormatterAdapter(self, options)
    }

}

private final class FormatterAdapter<Value: Equatable> : Formatter {

    init(_ format: TextInputFormat<Value>, _ options: FormatterOptions) {
        self.format = format
        self.options = options

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func string(for object: Any?) -> String? {
        guard let object = object else {
            return nil
        }

        guard let objectValue = object as? FormatterObjectValue<Value> else {
            fatalError("Unexpected type of an object passed to Formatter.string(for:) (expected: \(String(describing: FormatterObjectValue<Value>.self)), actual: \(String(describing: type(of: object))))")
        }

        if let value = objectValue.value {
            return format.serializer.string(for: value)
        }
        else {
            return objectValue.text
        }
    }

    override func getObjectValue(
        _ objectPtr: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription errorDescriptionPtr: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        let objectValue: FormatterObjectValue<Value>
        do {
            let value = try format.serializer.value(for: string)
            objectValue = .init(value: value, text: string)
        }
        catch let error {
            objectValue = .init(value: nil, text: string)

            if let error = error as? CustomStringConvertible, let errorDescriptionPtr = errorDescriptionPtr {
                errorDescriptionPtr.pointee = error.description as NSString
            }
        }

        if let objectPtr = objectPtr {
            objectPtr.pointee = objectValue as AnyObject
        }

        return true
    }

    override func isPartialStringValid(
        _ partialString: String,
        newEditingString newStringPtr: AutoreleasingUnsafeMutablePointer<NSString?>?,
        errorDescription errorDescriptionPtr: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        fatalError("\(#function) isn't implemented. It is not supported by a `Formatter` created by `TextInputFormat`.")
    }

    override func isPartialStringValid(
        _ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
        proposedSelectedRange proposedSelectedNSRangePtr: NSRangePointer?,
        originalString: String,
        originalSelectedRange editedNSRange: NSRange,
        errorDescription errorDescriptionPtr: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        let editedRange = editedNSRange.toRange()!
            .sameRange(in: originalString.utf16)
            .sameRange(in: originalString)

        let originalSelectedRange: Range<String.Index> = {
            #if os(macOS)
            if options.tracksCurrentEditorSelection {
                if let editor = NSApplication.shared().keyWindow?.textInputKit_currentEditor {
                    return editor.textInputKit_selectedRange!
                }
            }
            #endif
            return editedRange
        }()

        let editedString = partialStringPtr.pointee as String

        let resultingSelectedRange: Range<String.Index> = {
            if let proposedSelectedNSRangePtr = proposedSelectedNSRangePtr {
                return proposedSelectedNSRangePtr.pointee.toRange()!
                    .sameRange(in: editedString.utf16)
                    .sameRange(in: editedString)
            }
            return editedString.endIndex..<editedString.endIndex
        }()

        precondition(resultingSelectedRange.isEmpty,
                     "The proposed selected range after editing text should be empty (a blinking cursor).")
        precondition(originalString.substring(to: editedRange.lowerBound) == editedString.substring(to: editedRange.lowerBound),
                     "The strings before and after editing should have common prefix.")
        precondition(originalString.substring(from: editedRange.upperBound) == editedString.substring(from: resultingSelectedRange.lowerBound),
                     "The strings before and after editing should have common suffix.")

        let replacementString: String = editedString.substring(with: editedRange.lowerBound..<resultingSelectedRange.lowerBound)

        let validationResult = format.formatter.validate(
            editing: originalString,
            withSelection: originalSelectedRange,
            replacing: replacementString,
            at: editedRange)

        switch validationResult {
        case .accepted:
            return true

        case .changed(let newEditedString, let newSelectedRange):
            partialStringPtr.pointee = newEditedString as NSString
            proposedSelectedNSRangePtr?.pointee = NSRange(newSelectedRange
                .sameRange(in: newEditedString.utf16)
                .sameIntRange(in: newEditedString.utf16))

            return false

        case .rejected:
            return false
        }
    }

    private let format: TextInputFormat<Value>

    private let options: FormatterOptions

}
