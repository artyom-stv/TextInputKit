//
//  TextInputFormat+Filter.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormat {

    // The commented code crashes the compiler.
//    public typealias FilterPredicate = TextInputFormatterType.FilterPredicate

    public typealias FilterPredicate = (String) -> Bool

    func filter(_ predicate: @escaping FilterPredicate) -> TextInputFormat<Value> {
        return TextInputFormat.from(
            self.serializer,
            self.formatter.filter(predicate))
    }
    
}

public extension TextInputFormat {

    func filter(by characterSet: CharacterSet) -> TextInputFormat<Value> {
        let invertedCharacterSet = characterSet.inverted
        return filter {
            string in

            return string.rangeOfCharacter(from: invertedCharacterSet) == nil
        }
    }

    func filter(constrainingCharactersCount maxCharactersCount: Int) -> TextInputFormat<Value> {
        return filter {
            string in

            return (string.characters.count <= maxCharactersCount)
        }
    }

}
