//
//  TextInputDriver.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public class TextInputDriver<Value> : TextInputDriverType {

    public let format: TextInputFormat<Value>

    public init(_ format: TextInputFormat<Value>) {
        self.format = format
    }

    deinit {
        unbind()
    }

    public var value: Value? {
        get {
            abstractMethod()
        }
        set {
            abstractMethod()
        }
    }

    public func unbind() {
        abstractMethod()
    }

}
