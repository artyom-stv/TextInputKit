//
//  TextInputFormat+From.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public extension TextInputFormat {

    static func from<Value>(
        _ serializer: TextInputSerializer<Value>,
        _ formatter: TextInputFormatter) -> TextInputFormat<Value> {

        return TextInputFormat<Value>(serializer, formatter)
    }

}
