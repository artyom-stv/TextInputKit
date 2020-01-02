//
//  TextInputSerializer+Identical.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputSerializerType where Value == String {

    static var identical: TextInputSerializer<String> {
        return IdenticalTextInputSerializer()
    }

}

public final class IdenticalTextInputSerializer: TextInputSerializer<String> {

    public override func string(for value: String) -> String {
        return value
    }

    public override func value(for string: String) throws -> String {
        return string
    }
    
}
