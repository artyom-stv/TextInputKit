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

    func testThatDotsAndHyphensAreAcceptedWhenRequired() {
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
        textInput.expect("A", "", "")
        textInput.insert(" ")
        textInput.expect("A ", "", "")
        textInput.insert(".")
        textInput.expect("A ", "", "")
        textInput.insert("-")
        textInput.expect("A ", "", "")
    }

    func testThatSpacesAreRemovedWhenRequired() {
        textInput.insert("A B")
        textInput.expect("A B", "", "")

        textInput.select(1..<1)
        textInput.backspace()
        textInput.expect("", "", "B")
    }

    func testThatDotsAndSpacesAreRemovedWhenRequired() {
        textInput.insert("A. B. C.")
        textInput.expect("A. B. C.", "", "")

        textInput.select(7..<7)
        textInput.backspace()
        textInput.expect("A. B. ", "", "")

        textInput.select(1..<1)
        textInput.backspace()
        textInput.expect("", "", "B. ")

        textInput.selectAll()
        textInput.insert("A. B. C.")
        textInput.expect("A. B. C.", "", "")

        textInput.select(4..<4)
        textInput.backspace()
        textInput.expect("A. ", "", "C.")
    }

    func testThatHyphensAndSpacesAreRemovedWhenRequired() {
        textInput.insert("A-B D-E-F")
        textInput.expect("A-B D-E-F", "", "")

        textInput.select(1..<1)
        textInput.backspace()
        textInput.expect("", "", "B D-E-F")

        textInput.select(5..<5)
        textInput.backspace()
        textInput.expect("B D-", "", "F")

        textInput.select(3..<3)
        textInput.backspace()
        textInput.expect("B ", "", "F")
    }

    func testThatDigitsAreNotAccepted() {
        for digitScalar in UnicodeScalar("0").value...UnicodeScalar("9").value {
            let digitString = String(UnicodeScalar(digitScalar)!)
            textInput.insert(digitString)
            textInput.expect("", "", "")
        }
    }

    func testThatDiacriticsIsRemovedFromLetters() {
        let lettersWithDiacritics    = "ÁÀÂÄǍĂĀÃÅǺĆĊĈČĎÉÈĖÊËĚĔĒÍÌİÎÏǏĬĪĨŃN̈ŇÑÓÒÔÖǑŎŌÕŐáàâäǎăāãåǻćċĉčéèėêëěĕēíìiîïǐĭīĩńn̈ňñóòôöǒŏōõő"
        let lettersWithoutDiacritics = "AAAAAAAAAACCCCDEEEEEEEEIIIIIIIIINNNNOOOOOOOOOaaaaaaaaaacccceeeeeeeeiiiiiiiiinnnnooooooooo"
        for (letterWithDiacritics, letterWithoutDiacritics) in zip(lettersWithDiacritics.characters, lettersWithoutDiacritics.characters) {
            textInput.selectAll()
            textInput.insert(String(letterWithDiacritics))
            textInput.expect(String(letterWithoutDiacritics).uppercased(), "", "")
        }
    }

}
