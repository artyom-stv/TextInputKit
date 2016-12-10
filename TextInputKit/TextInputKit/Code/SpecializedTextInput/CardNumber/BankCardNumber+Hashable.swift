//
//  BankCardNumber+Hashable.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 10/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

extension BankCardNumber : Hashable {

    public var hashValue: Int {
        return digitsString.hashValue
    }

}
