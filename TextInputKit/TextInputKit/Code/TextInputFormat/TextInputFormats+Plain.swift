//
//  TextInputFormats+Plain.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormats {

    /// Creates the most primitive `TextInputFormat` with `String` value type:
    /// it doesn't affect text input and exposes the inputted text as a value.
    static var plain: TextInputFormat<String> {
        return TextInputFormat<String>.from(TextInputSerializer.identical, TextInputFormatter.plain)
    }

}
