//
//  TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 23/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

func abstractMethod() -> Never {
    fatalError("Abstract method.")
}

func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    Swift.fatalError(message(), file: file, line: line)
}
