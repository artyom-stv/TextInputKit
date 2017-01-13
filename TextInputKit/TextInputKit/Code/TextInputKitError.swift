//
//  TextInputKitError.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public enum TextInputKitError : Error {

    case unknown

    case missingFramework(frameworkName: String)
    
}

extension TextInputKitError : CustomStringConvertible {

    public var description: String {
        switch self {
        case .unknown:
            return "Unknown error."

        case .missingFramework(let frameworkName):
            return "Framework \"\(frameworkName)\" isn't loaded."
        }
    }

}
