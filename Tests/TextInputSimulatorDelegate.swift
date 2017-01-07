//
//  TextInputSimulatorDelegate.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 05/01/2017.
//  Copyright © 2017 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import TextInputKit

protocol TextInputSimulatorDelegate : class {

    func editingDidBegin()

    func editingChanged()

    func editingDidEnd()

    func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult

}
