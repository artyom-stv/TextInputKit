//
//  BankCardTextField.swift
//  Example
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import UIKit

final class BankCardTextField : UITextField {

    // MARK: - Override NSObject

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = Style.borderColor.cgColor
        layer.cornerRadius = Style.cornerRadius
    }

    // MARK: - Override UIView

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        if let window = newWindow {
            layer.borderWidth = Style.borderWidth / window.screen.scale
        }
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += type(of: self).inset.width
        size.height += type(of: self).inset.height
        return size
    }

    // MARK: - Override UITextField

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(
            dx: type(of: self).inset.width,
            dy: type(of: self).inset.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(
            dx: type(of: self).inset.width,
            dy: type(of: self).inset.height)
    }

    // MARK: - Private Types

    private typealias Style = BankCardTextFieldStyle

    // MARK: - Private Constants

    private static let inset: CGSize = CGSize(width: CGFloat(8.0), height: CGFloat(3.0))
    
}
