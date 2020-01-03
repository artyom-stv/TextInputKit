//
//  NSWindow+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 19/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(macOS)

import AppKit

extension NSWindow {

    var currentEditor: NSText? {
        if let editor = fieldEditor(false, for: nil), firstResponder == editor {
            return editor
        }
        return nil
    }

}

#endif
