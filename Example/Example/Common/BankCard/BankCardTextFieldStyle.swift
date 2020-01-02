//
//  BankCardTextFieldStyle.swift
//  Example
//
//  Created by Artem Starosvetskiy on 21/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

struct BankCardTextFieldStyle {

    static let borderWidth: CGFloat = 1.0
    static let borderColor: Color = Color(white: CGFloat(0.0), alpha: CGFloat(0.2))
    static let cornerRadius: CGFloat = 3.0

}
