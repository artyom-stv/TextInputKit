//
//  PhoneNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct PhoneNumber {

    public let formattedString: String

    public let number: String

    init(formattedString: String, number: String) {
        self.formattedString = formattedString
        self.number = number
    }

}

extension PhoneNumber : Equatable {

    public static func ==(lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        // TODO: Implement.
        return lhs.formattedString == rhs.formattedString
    }

}

extension PhoneNumber : Hashable {

    public var hashValue: Int {
        // TODO: Implement.
        return formattedString.hashValue
    }
    
}
