//
//  BankCardTextField.swift
//  Example
//
//  Created by Artem Starosvetskiy on 16/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Cocoa

final class BankCardTextField: NSTextField {

    // MARK: - Override NSObject

    override func awakeFromNib() {
        super.awakeFromNib()

        wantsLayer = true

        guard let layer = self.layer else {
            fatalError("A layer should be attached because `wantsLayer` is set to `true`.")
        }

        layer.borderColor = Style.borderColor.cgColor
        layer.cornerRadius = Style.cornerRadius
        layer.borderWidth = Style.borderWidth
    }

    // MARK: - Override NSView

    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width += type(of: self).inset.width
        size.height += type(of: self).inset.height
        return size
    }

    // MARK: - Override NSControl

    override class var cellClass: Swift.AnyClass? {
        get {
            return BankCardTextFieldCell.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            fatalError()
        }
    }

    // MARK: - Private Types

    private typealias Style = BankCardTextFieldStyle

    // MARK: - Private Constants

    static let inset: CGSize = CGSize(width: CGFloat(8.0), height: CGFloat(3.0))

}
