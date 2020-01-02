//
//  TextInputSerializerType.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 23/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public protocol TextInputSerializerType: class {

    associatedtype Value

    func string(for value: Value) -> String

    func value(for string: String) throws -> Value

}
