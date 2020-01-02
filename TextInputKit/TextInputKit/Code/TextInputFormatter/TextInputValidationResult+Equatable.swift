//
//  TextInputValidationResult+Equatable.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 02/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

extension TextInputValidationResult: Equatable {

    public static func ==(lhs: TextInputValidationResult, rhs: TextInputValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.accepted, .accepted):
            return true

        case (.changed(let lhsString, let lhsRange), .changed(let rhsString, let rhsRange))
            where lhsString == rhsString && lhsRange == rhsRange:

            return true

        case (.rejected, .rejected):
            return true

        default:
            return false
        }
    }

}
