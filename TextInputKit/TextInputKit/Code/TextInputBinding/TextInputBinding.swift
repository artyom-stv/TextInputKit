//
//  TextInputBinding.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

open class TextInputBinding<Value> : TextInputBindingType {

    public let format: TextInputFormat<Value>

    public init(_ format: TextInputFormat<Value>) {
        self.format = format
    }

    deinit {
        unbind()
    }

    open var value: Value? {
        get {
            abstractMethod()
        }
        set {
            abstractMethod()
        }
    }

    open func unbind() {
        abstractMethod()
    }

}
