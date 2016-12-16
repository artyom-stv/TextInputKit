//
//  TextInputFormat+Bind.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public protocol TextInputFormatBindable {

    func bind<Value>(format: TextInputFormat<Value>) -> TextInputBinding<Value>

}

public extension TextInputFormat {

    func bind<TextInput: TextInputFormatBindable>(to textInput: TextInput) -> TextInputBinding<Value> {
        return textInput.bind(format: self)
    }

}
