//
//  PhoneNumber.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 25/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct PhoneNumber {

    init(_ pnkPhoneNumber: PNKPhoneNumber) {
        self.pnkPhoneNumber = pnkPhoneNumber
    }

    let pnkPhoneNumber: PNKPhoneNumber

}

extension PhoneNumber : Equatable {

    public static func ==(lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        return lhs.pnkPhoneNumber == rhs.pnkPhoneNumber
    }

}

extension PhoneNumber : Hashable {

    public var hashValue: Int {
        return pnkPhoneNumber.hashValue
    }

}
