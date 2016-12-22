//
//  Types.swift
//  Example
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

#if os(macOS)
    typealias Color = NSColor
    typealias ViewController = NSViewController
    typealias TextField = NSTextField
#else
    typealias Color = UIColor
    typealias ViewController = UIViewController
    typealias TextField = UITextField
#endif
