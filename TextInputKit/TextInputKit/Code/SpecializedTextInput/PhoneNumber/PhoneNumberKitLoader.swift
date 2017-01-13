//
//  PhoneNumberKitLoader.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import PhoneNumberKit

/// A `PhoneNumberKitLoader` incapsulates the logic of loading a `PhoneNumberKit` in background.
final class PhoneNumberKitLoader {

    // MARK: Nested Types

    /// A `Task` class represents a task for loading a `PhoneNumberKit` in background.
    final class Task {

        /// Waits for a `PhoneNumberKit` to be loaded.
        ///
        /// - Returns: The loaded `PhoneNumberKit`.
        func wait() -> PhoneNumberKit {
            workItem?.wait()
            workItem = nil

            return phoneNumberKit!
        }

        fileprivate typealias CompletionHandler = (PhoneNumberKit) -> ()

        fileprivate init(completion: CompletionHandler) {
            workItem = DispatchWorkItem { [weak weakSelf = self] in
                if let strongSelf = weakSelf {
                    let phoneNumberKit = PhoneNumberKit()

                    strongSelf.phoneNumberKit = phoneNumberKit

                    strongSelf.completion?(phoneNumberKit)
                    strongSelf.completion = nil
                }
            }
        }

        fileprivate func schedule(on queue: DispatchQueue) {
            guard let workItem = workItem else {
                return
            }

            queue.async(execute: workItem)
        }

        private var workItem: DispatchWorkItem?

        private var phoneNumberKit: PhoneNumberKit?

        private var completion: CompletionHandler?

    }

    // MARK: Shared Instance.

    /// Holds a shared `PhoneNumberKitLoader`.
    static let shared = PhoneNumberKitLoader()

    // MARK: Properties

    /// Creates a `CachedPhoneNumberKit`.
    var cachedPhoneNumberKit: CachedPhoneNumberKit {
        return loadingMutex.fastsync {
            if let phoneNumberKit = cache.object {
                return CachedPhoneNumberKit(phoneNumberKit)
            }
            else {
                let task = startLoading()
                return CachedPhoneNumberKit(task)
            }
        }
    }

    // MARK: Private Initializer

    private init() {
        self.queue = DispatchQueue.global(qos: .utility)
        self.cache = ObjectCache<PhoneNumberKit>(queue: queue)
    }

    // MARK: Private Stored Properties

    private let loadingMutex = PThreadMutex()

    private let queue: DispatchQueue

    private let cache: ObjectCache<PhoneNumberKit>

    private var task: Task?

    private func startLoading() -> Task {
        if let currentTask = task {
            return currentTask
        }

        let currentTask = Task(completion: { [weak weakSelf = self] phoneNumberKit in
            if let strongSelf = weakSelf {
                strongSelf.loadingMutex.fastsync {
                    strongSelf.cache.object = phoneNumberKit
                }
            }
        })
        currentTask.schedule(on: queue)

        task = currentTask

        return currentTask
    }

}
