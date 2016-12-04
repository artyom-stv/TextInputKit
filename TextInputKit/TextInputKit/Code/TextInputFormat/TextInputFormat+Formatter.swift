//
//  TextInputFormat+Formatter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

extension TextInputFormat {

    public func toFormatter() -> Formatter {
        return FormatterAdapter(self)
    }

}

private final class FormatterAdapter<Value> : Formatter {

    init(_ format: TextInputFormat<Value>) {
        self.format = format

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func string(for object: Any?) -> String? {
        guard let object = object else {
            return nil
        }

        guard let value = object as? Value else {
            fatalError("Unexpected type of an object passed to Formatter.string(for:) (expected: \(String(describing: Value.self)), actual: \(String(describing: type(of: object))))")
        }
        return format.serializer.string(for: value)
    }

    override func getObjectValue(
        _ objectPtr: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription errorDescriptionPtr: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        do {
            let value = try format.serializer.value(for: string)

            if let objectPtr = objectPtr {
                objectPtr.pointee = value as AnyObject
            }

            return true
        }
        catch let error {
            if let error = error as? CustomStringConvertible, let errorDescriptionPtr = errorDescriptionPtr {
                errorDescriptionPtr.pointee = error.description as NSString
            }

            return false
        }
    }

    override func isPartialStringValid(
        _ partialString: String,
        newEditingString newStringPtr: AutoreleasingUnsafeMutablePointer<NSString?>?,
        errorDescription errorDescriptionPtr: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        fatalError("\(#function) has not been implemented")
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
            withSelection: editedRange,
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

}
