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
