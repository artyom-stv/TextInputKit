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

    let textInputFormat = TextInputFormats.bankCardHolderName()

    var textInput: TextInputSimulator!

    var textInputBinding: TextInputBinding<String>!

    override func setUp() {
        super.setUp()

        textInput = TextInputSimulator()
        textInputBinding = textInputFormat.bind(to: textInput)
    }

    func testThatUppercaseLatinLettersAndSpacesAreAccepted() {
        textInput.edit { editor in
            editor.insert("A")
            textInput.expect("A", "", "")
            editor.insert("B")
            textInput.expect("AB", "", "")
            editor.insert(" ")
            textInput.expect("AB ", "", "")
            editor.insert("C")
            textInput.expect("AB C", "", "")
            editor.insert("D")
            textInput.expect("AB CD", "", "")
        }
    }

    func testThatLatinLettersAreUppercased() {
        textInput.edit { editor in
            editor.insert("a")
            textInput.expect("A", "", "")
            editor.insert("b")
            textInput.expect("AB", "", "")
        }
    }

    func testThatDotsAndHyphensAreAcceptedWhenRequired() {
        textInput.edit { editor in
            editor.insert("A")
            textInput.expect("A", "", "")
            editor.insert(".")
            textInput.expect("A.", "", "")
            editor.insert(" ")
            textInput.expect("A. ", "", "")
            editor.insert("B")
            textInput.expect("A. B", "", "")
            editor.insert("-")
            textInput.expect("A. B-", "", "")
            editor.insert("C")
            textInput.expect("A. B-C", "", "")
        }
    }

    func testThatDotsAndHyphensAreNotAcceptedAtTheBeginningOfWords() {
        textInput.edit { editor in
            editor.insert(".")
            textInput.expect("", "", "")
            editor.insert("-")
            textInput.expect("", "", "")
            editor.insert("A")
            textInput.expect("A", "", "")
            editor.insert(" ")
            textInput.expect("A ", "", "")
            editor.insert(".")
            textInput.expect("A ", "", "")
            editor.insert("-")
            textInput.expect("A ", "", "")
        }
    }

    func testThatSpacesAreRemovedWhenRequired() {
        textInput.edit { editor in
            editor.insert("A B")
            textInput.expect("A B", "", "")
        }

        textInput.edit { editor in
            editor.select(1..<1)
            editor.backspace()
            textInput.expect("", "", "B")
        }
    }

    func testThatDotsAndSpacesAreRemovedWhenRequired() {
        textInput.edit { editor in
            editor.insert("A. B. C.")
            textInput.expect("A. B. C.", "", "")
        }

        textInput.edit { editor in
            editor.select(7..<7)
            editor.backspace()
            textInput.expect("A. B. ", "", "")

            editor.select(1..<1)
            editor.backspace()
            textInput.expect("", "", "B. ")

            editor.selectAll()
            editor.insert("A. B. C.")
            textInput.expect("A. B. C.", "", "")

            editor.select(4..<4)
            editor.backspace()
            textInput.expect("A. ", "", "C.")
        }
    }

    func testThatHyphensAndSpacesAreRemovedWhenRequired() {
        textInput.edit { editor in
            editor.insert("A-B D-E-F")
            textInput.expect("A-B D-E-F", "", "")
        }

        textInput.edit { editor in
            editor.select(1..<1)
            editor.backspace()
            textInput.expect("", "", "B D-E-F")

            editor.select(5..<5)
            editor.backspace()
            textInput.expect("B D-", "", "F")

            editor.select(3..<3)
            editor.backspace()
            textInput.expect("B ", "", "F")
        }
    }

    func testThatDigitsAreNotAccepted() {
        textInput.edit { editor in
            for digitScalar in UnicodeScalar("0").value...UnicodeScalar("9").value {
                let digitString = String(UnicodeScalar(digitScalar)!)
                editor.insert(digitString)
                textInput.expect("", "", "")
            }
        }
    }

    func testThatDiacriticsIsNotAccepted() {
        let lettersWithDiacritics = "ÁÀÂÄǍĂĀÃÅǺĆĊĈČĎÉÈĖÊËĚĔĒÍÌİÎÏǏĬĪĨŃN̈ŇÑÓÒÔÖǑŎŌÕŐáàâäǎăāãåǻćċĉčéèėêëěĕēíìîïǐĭīĩńn̈ňñóòôöǒŏōõő"
        textInput.edit { editor in
            for letterWithDiacritics in lettersWithDiacritics.characters {
                editor.insert(String(letterWithDiacritics))
                textInput.expect("", "", "")
            }
        }
    }

}
