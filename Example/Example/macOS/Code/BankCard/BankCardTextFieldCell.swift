//
//  BankCardTextFieldCell.swift
//  Example
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import AppKit

final class BankCardTextFieldCell: NSTextFieldCell {
    // MARK: - Override NSView

    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        return rect.insetBy(
            dx: BankCardTextField.inset.width,
            dy: BankCardTextField.inset.height)
    }

    override func titleRect(forBounds rect: NSRect) -> NSRect {
        return rect.insetBy(
            dx: BankCardTextField.inset.width,
            dy: BankCardTextField.inset.height)
    }
}
