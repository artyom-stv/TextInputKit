//
//  CountableClosedRange+Tests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 02/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

extension CountableClosedRange {

    func contains(_ range: Range<Bound>) -> Bool {
        return (lowerBound <= range.lowerBound) && (upperBound.advanced(by: 1) >= range.upperBound)
    }

    func contains(_ range: ClosedRange<Bound>) -> Bool {
        return (lowerBound <= range.lowerBound) && (upperBound >= range.upperBound)
    }

}
