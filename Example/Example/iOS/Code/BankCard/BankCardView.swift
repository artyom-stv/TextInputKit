//
//  BankCardView.swift
//  Example
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import UIKit

final class BankCardView : UIView {

    // MARK: - Override NSObject

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = type(of: self).borderColor.cgColor
        layer.cornerRadius = type(of: self).cornerRadius
    }

    // MARK: - Override UIView

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        if let window = newWindow {
            layer.borderWidth = type(of: self).borderWidth / window.screen.scale
        }
    }

    // MARK: - Constants

    private static let borderWidth: CGFloat = 1.0
    private static let borderColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.2))
    private static let cornerRadius: CGFloat = 10.0

}
