//
//  String+Tests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 14/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

extension String {

    /// Checks if the index is valid in the context of the callee string.
    ///
    /// - Note: In Swift 3, it isn't possible to implement such a check correctly. The current implementation gives
    /// false-positive (returns `true`) in such case: `"a".isValidIndex("ab".index(after: "ab".startIndex))`.
    /// But still, it is better than nothing.
    ///
    /// - Parameter index: The string index.
    /// - Returns: Is the index valid in the context of the callee string.
    func isValidIndex(_ index: String.Index) -> Bool {
        if index > endIndex {
            return false
        }

        if index == endIndex {
            return true
            // To eliminate the false-positive result, we could have written the following code. But it may crash.
            // return self.characters[index...index].isEmpty
        }

        if self.characters[index...index].count != 1 {
            return false
        }

        let possiblySameIndex = (index == startIndex) ? startIndex : self.index(after: self.index(before: index))
        return (self[index] == self[possiblySameIndex])
    }

}
