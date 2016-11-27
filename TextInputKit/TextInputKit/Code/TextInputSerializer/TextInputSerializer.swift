//
//  TextInputSerializer.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 23/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

open class TextInputSerializer<Value> : TextInputSerializerType {

    init() {
    }

    public func string(for value: Value) -> String {
        abstractMethod()
    }

    public func value(for string: String) throws -> Value {
        abstractMethod()
    }

}
