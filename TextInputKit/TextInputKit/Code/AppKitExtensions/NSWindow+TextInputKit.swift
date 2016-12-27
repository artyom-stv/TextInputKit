//
//  NSWindow+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 19/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import AppKit

extension NSWindow {

    var textInputKit_currentEditor: NSText? {
        if let editor = fieldEditor(false, for: nil), firstResponder == editor {
            return editor
        }
        return nil
    }

}