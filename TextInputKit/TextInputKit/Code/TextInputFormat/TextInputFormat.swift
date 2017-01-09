//
//  TextInputFormat.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 24/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct TextInputFormat<Value: Equatable> {

    public init(_ serializer: TextInputSerializer<Value>, _ formatter: TextInputFormatter) {
        self.serializer = serializer
        self.formatter = formatter
    }

    public let serializer: TextInputSerializer<Value>

    public let formatter: TextInputFormatter

}
