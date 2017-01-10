//
//  TextInputBinding.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

open class TextInputBinding<Value: Equatable> : TextInputBindingType {

    open var text: String {
        get {
            abstractMethod()
        }
        set {
            abstractMethod()
        }
    }

    open var selectedRange: Range<String.Index>? {
        get {
            abstractMethod()
        }
        set {
            abstractMethod()
        }
    }

    open var value: Value? {
        get {
            abstractMethod()
        }
        set {
            abstractMethod()
        }
    }

    open var eventHandler: EventHandler? {
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

    public typealias EventHandler = (TextInputEvent<Value>) -> ()

    public let format: TextInputFormat<Value>

    public init(_ format: TextInputFormat<Value>) {
        self.format = format
    }

    deinit {
        unbind()
    }

}
