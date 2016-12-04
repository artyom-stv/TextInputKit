//
//  Range+TextInputKit.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 23/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

protocol RangeType {

    associatedtype Bound

    var lowerBound: Bound { get }

    var upperBound: Bound { get }

}

extension Range : RangeType {
    
}

extension RangeType where Bound == Int {

    func sameRange(in view: String.UTF16View) -> Range<String.UTF16View.Index> {
        guard
            let resultLowerBound = view.index(view.startIndex, offsetBy: lowerBound, limitedBy: view.endIndex),
            let resultUpperBound = view.index(resultLowerBound, offsetBy: (upperBound - lowerBound), limitedBy: view.endIndex)
            else {
                fatalError("Range is out of string view bounds.")
        }

        return resultLowerBound..<resultUpperBound
    }

}

extension RangeType where Bound == String.UTF16View.Index {

    func sameIntRange(in view: String.UTF16View) -> Range<Int> {
        let resultLowerBound = view.distance(from: view.startIndex, to: lowerBound)
        let resultUpperBound = resultLowerBound + view.distance(from: lowerBound, to: upperBound)
        return resultLowerBound..<resultUpperBound
    }

    func sameRange(in string: String) -> Range<String.Index> {
        guard
            let resultLowerBound = lowerBound.samePosition(in: string),
            let resultUpperBound = upperBound.samePosition(in: string)
            else {
                fatalError("Wrong string view index.")
        }
        return resultLowerBound..<resultUpperBound
    }

}

extension RangeType where Bound == String.Index {

    func sameRange(in view: String.UTF16View) -> Range<String.UTF16View.Index> {
        let resultLowerBound = lowerBound.samePosition(in: view)
        let resultUpperBound = upperBound.samePosition(in: view)
        return resultLowerBound..<resultUpperBound
    }

    func sameRange(in view: String.UnicodeScalarView) -> Range<String.UnicodeScalarView.Index> {
        let resultLowerBound = lowerBound.samePosition(in: view)
        let resultUpperBound = upperBound.samePosition(in: view)
        return resultLowerBound..<resultUpperBound
    }

}
