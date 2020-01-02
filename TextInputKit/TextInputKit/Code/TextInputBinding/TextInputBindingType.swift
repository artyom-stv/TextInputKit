//
//  TextInputBindingType.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public protocol TextInputBindingType: class {

    associatedtype Value: Equatable

    typealias EventHandler = (TextInputEvent<Value>) -> ()

    var text: String { get set }

    var selectedRange: Range<String.Index>? { get set }

    var value: Value? { get set }

    var eventHandler: EventHandler? { get set }

    func unbind()
    
}
