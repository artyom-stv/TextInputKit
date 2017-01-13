//
//  PhoneNumberKit+Framework.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import PhoneNumberKit

extension PhoneNumberKit {

    static func checkThatFrameworkIsLoaded() throws {
        let isPhoneNumberKitFrameworkLoaded = (NSClassFromString("PhoneNumberKit.PhoneNumberKit") != nil)
        if !isPhoneNumberKitFrameworkLoaded {
            throw TextInputKitError.missingFramework(frameworkName: "PhoneNumberKit")
        }
    }
    
}
