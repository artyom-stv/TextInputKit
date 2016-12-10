//
//  BankCardNumber+Equatable.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 10/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

extension BankCardNumber : Equatable {

    public static func ==(lhs: BankCardNumber, rhs: BankCardNumber) -> Bool {
        return lhs.digitsString == rhs.digitsString
    }
    
}
