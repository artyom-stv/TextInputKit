//
//  MutableBox.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

class MutableBox<T> {

    var value: T

    init (_ value: T) {
        self.value = value
    }

}
