//
//  BankCardHolderNameTextInputFormatterTests.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 19/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import XCTest
@testable import TextInputKit

final class BankCardHolderNameTextInputFormatterTests : XCTestCase {

    let textInputFormatter = BankCardHolderNameTextInputFormatter(.options())

    var textInput: TextInputSimulator!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator(textInputFormatter)
    }

    func testThatUppercaseLatinLettersAndSpacesAreAccepted() {
        textInput.insert("A")
        textInput.expect("A", "", "")
        textInput.insert("B")
        textInput.expect("AB", "", "")
        textInput.insert(" ")
        textInput.expect("AB ", "", "")
        textInput.insert("C")
        textInput.expect("AB C", "", "")
        textInput.insert("D")
        textInput.expect("AB CD", "", "")
    }

    func testThatLatinLettersAreUppercased() {
        textInput.insert("a")
        textInput.expect("A", "", "")
        textInput.insert("b")
        textInput.expect("AB", "", "")
    }

    func testThatDotsAndHyphensAreAccepted() {
        textInput.insert("A")
        textInput.expect("A", "", "")
        textInput.insert(".")
        textInput.expect("A.", "", "")
        textInput.insert(" ")
        textInput.expect("A. ", "", "")
        textInput.insert("B")
        textInput.expect("A. B", "", "")
        textInput.insert("-")
        textInput.expect("A. B-", "", "")
        textInput.insert("C")
        textInput.expect("A. B-C", "", "")
    }

    func testThatDotsAndHyphensAreNotAcceptedAtTheBeginningOfWords() {
        textInput.insert(".")
        textInput.expect("", "", "")
        textInput.insert("-")
        textInput.expect("", "", "")
        textInput.insert("A")
        textInput.expect("A ", "", "")
        textInput.insert(" ")
        textInput.expect("A ", "", "")
        textInput.insert(".")
        textInput.expect("A ", "", "")
        textInput.insert("-")
        textInput.expect("A ", "", "")
    }

    func testThatDigitsAreNotAccepted() {
    }

    func testThatDiacriticsIsNotAccepted() {
    }

}
