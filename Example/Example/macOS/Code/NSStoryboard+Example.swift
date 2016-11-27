//
//  NSStoryboard+Example.swift
//  Example
//
//  Created by Artem Starosvetskiy on 20/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import Cocoa

extension NSStoryboard {

    func instantiateController<ViewController>(_ type: ViewController.Type) -> ViewController {
        return instantiateController(withIdentifier: String(describing: type)) as! ViewController
    }

}
