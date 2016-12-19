//
//  BankCardTextField.swift
//  Example
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Cocoa

final class BankCardTextField : NSTextField {

    // MARK: - Override NSObject

    override func awakeFromNib() {
        super.awakeFromNib()

        self.wantsLayer = true
        layer!.borderColor = type(of: self).borderColor.cgColor
        layer!.cornerRadius = type(of: self).cornerRadius
        layer!.borderWidth = type(of: self).borderWidth
    }

    // MARK: - Override NSView

    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width += type(of: self).inset.width
        size.height += type(of: self).inset.height
        return size
    }

    // MARK: - Override NSControl

    override class func cellClass() -> Swift.AnyClass? {
        return BankCardTextFieldCell.self
    }

    // MARK: - Constants

    static let inset: CGSize = CGSize(width: CGFloat(8.0), height: CGFloat(3.0))

    private static let borderWidth: CGFloat = 1.0
    private static let borderColor = NSColor(white: CGFloat(0.0), alpha: CGFloat(0.2))
    private static let cornerRadius: CGFloat = 3.0

}
