//
//  TextInputFormat+Map.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormat {

    // The commented code crashes the compiler.
//    public typealias MapTransform = TextInputFormatterType.MapTransform

    public typealias MapTransform = (String, Range<String.Index>) -> (String, Range<String.Index>)

    func map(_ transform: @escaping MapTransform) -> TextInputFormat<Value> {
        return TextInputFormat.from(
            self.serializer,
            self.formatter.map(transform))
    }

}

public extension TextInputFormat {

    func map(constrainingCharactersCount maxCharactersCount: Int) -> TextInputFormat<Value> {
        return map {
            (string, selectedRange) in

            let resultEndIndex = string.index(string.startIndex, offsetBy: maxCharactersCount, limitedBy: string.endIndex)
            if let resultEndIndex = resultEndIndex, resultEndIndex != string.endIndex {
                let newString = string.substring(to: resultEndIndex)
                let newSelectedRange = selectedRange.clamped(to: string.startIndex..<resultEndIndex)

                return (newString, newSelectedRange)
            }

            return (string, selectedRange)
        }
    }

}
