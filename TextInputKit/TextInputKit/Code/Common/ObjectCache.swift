//
//  ObjectCache.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 13/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation

#if !os(macOS)
import UIKit
#endif

/// A cache for one object.
///
/// Always keeps a weak reference to the object.
/// Keeps a strong reference to the object until one of the conditions is met:
/// - memory is needed by other applications (NSCache auto-eviction policy);
/// - on UIKit (iOS, tvOS), a memory warning is received.
final class ObjectCache<Object: AnyObject> {

    /// An `Object` stored in the cache.
    ///
    /// - Note: Not thread-safe: can be accessed from different thread, but can't be accessed concurrently.
    var object: Object? {
        get {
            if let object = weakRef {
                return object
            }
            return nsCache.object(forKey: nsCacheKey)
        }
        set(newObject) {
            weakRef = newObject
            if let newObject = newObject {
                nsCache.setObject(newObject, forKey: nsCacheKey)
            }
            else {
                nsCache.removeAllObjects()
            }
        }
    }

    /// Creates an `ObjectCache`.
    ///
    /// - Parameters:
    ///   - queue: A dispatch queue on which notifications from `NotificationCenter` are observed.
    init(queue: DispatchQueue = .main) {
        #if !os(macOS)
            self.memoryWarningResponder = MemoryWarningResponder(queue: queue)
            self.memoryWarningResponder.action = { [unowned self] in
                self.nsCache.removeAllObjects()
            }
        #endif
    }

    #if !os(macOS)
    private let memoryWarningResponder: MemoryWarningResponder
    #endif

    private let nsCache = NSCache<NSObject, Object>()
    
    private let nsCacheKey = NSObject()
    
    private weak var weakRef: Object?
    
}

#if !os(macOS)
private class MemoryWarningResponder {

    typealias Action = () -> ()

    var action: Action?

    init(queue: DispatchQueue) {
        self.queue = queue

        NotificationCenter.default.addObserver(self, selector: #selector(MemoryWarningResponder.didReceiveMemoryWarning(_:)), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private let queue: DispatchQueue

    @objc
    private func didReceiveMemoryWarning(_ notification: Notification) {
        action?()
    }
    
}
#endif
