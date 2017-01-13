//
//  CachedPhoneNumberKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import PhoneNumberKit

/// A `CachedPhoneNumberKit` provides access to a cached `PhoneNumberKit`.
///
/// Under the hood, if the cache was cleaned up, `CachedPhoneNumberKit` waits for a `PhoneNumberKit` to be loaded to
/// the cache again. Further, see `PhoneNumberKitLoader`.
final class CachedPhoneNumberKit {

    // MARK: Properties

    /// Returns a `PhoneNumberKit`.
    var instance: PhoneNumberKit {
        return stateMutex.fastsync {
            switch state {
            case .loaded(let phoneNumberKit):
                return phoneNumberKit

            case .loading(let loaderTask):
                let phoneNumberKit = loaderTask.wait()
                state = .loaded(phoneNumberKit)
                return phoneNumberKit
            }
        }
    }

    // MARK: Initializers

    convenience init(_ phoneNumberKit: PhoneNumberKit) {
        self.init(state: .loaded(phoneNumberKit))
    }

    convenience init(_ loaderTask: PhoneNumberKitLoader.Task) {
        self.init(state: .loading(loaderTask))
    }

    // MARK: Nested Types

    private enum State {

        case loaded(PhoneNumberKit)

        case loading(PhoneNumberKitLoader.Task)

    }

    private var stateMutex = PThreadMutex()

    private var state: State

    // MARK: Private Initializers

    private init(state: State) {
        self.state = state
    }

}
