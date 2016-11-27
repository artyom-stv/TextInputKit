//
//  TextInputFormats+Plain.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormats {

    static var plain: TextInputFormat<String> {
        return TextInputFormat<String>.from(TextInputSerializer.identical, TextInputFormatter.plain)
    }

}
