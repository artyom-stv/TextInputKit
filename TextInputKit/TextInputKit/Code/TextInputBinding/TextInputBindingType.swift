//
//  TextInputBindingType.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public protocol TextInputBindingType : class {

    associatedtype Value

    var value: Value? { get set }

    func unbind()
    
}
