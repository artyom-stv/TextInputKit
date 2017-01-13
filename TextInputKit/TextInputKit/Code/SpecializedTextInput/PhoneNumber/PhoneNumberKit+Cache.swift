//
//  PhoneNumberKit+Cache.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import PhoneNumberKit

extension PhoneNumberKit {

    /// Creates a `CachedPhoneNumberKit`.
    static var cached: CachedPhoneNumberKit {
        return PhoneNumberKitLoader.shared.cachedPhoneNumberKit
    }
    
}
