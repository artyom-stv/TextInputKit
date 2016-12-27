//
//  BankCardHolderNameUtils.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

struct BankCardHolderNameUtils {

    private init() {}

    static let allowedLetterCharacters: CharacterSet = {
        let latinUppercaseLetters = CharacterSet(charactersIn: UnicodeScalar("A")...UnicodeScalar("Z"))
        let fullwidthLatinUppercaseLetters = CharacterSet(charactersIn: UnicodeScalar("Ａ")...UnicodeScalar("Ｚ"))
        return latinUppercaseLetters
            .union(fullwidthLatinUppercaseLetters)
    }()

    static let allowedNonLetterCharacters = CharacterSet(charactersIn: "-. ")

    static let deniedCharacters: CharacterSet = {
        return allowedLetterCharacters
            .union(allowedNonLetterCharacters)
            .inverted
    }()

}

extension BankCardHolderNameUtils {

    static func stringViewAndIndexAfterFilteringPunctuation(
        in stringView: String.UnicodeScalarView,
        withIndex index: String.UnicodeScalarIndex
        ) -> (String.UnicodeScalarView, String.UnicodeScalarIndex) {

        var filter = PunctuationFilter(stringView, index)
        filter.filter()
        return (filter.resultingStringView, filter.resultingIndex)
    }

    private struct PunctuationFilter {

        private(set) var resultingStringView: String.UnicodeScalarView
        private(set) var resultingIndex: String.UnicodeScalarIndex

        init(_ stringView: String.UnicodeScalarView, _ index: String.UnicodeScalarIndex) {
            self.originalStringView = stringView
            self.originalIndex = index
            self.index = stringView.startIndex
            self.resultingStringView = "".unicodeScalars
            self.resultingIndex = self.resultingStringView.endIndex

            self.resultingStringView.reserveCapacity(stringView.count)
        }

        mutating func filter() {
            precondition(index == originalStringView.startIndex)
            precondition((originalIndex >= originalStringView.startIndex) && (originalIndex <= originalStringView.endIndex))

            if index == originalStringView.endIndex {
                return
            }

            skipAnyNonLetterCharacters()

            while index != originalStringView.endIndex {
                appendLetterCharacters()
                if index == originalStringView.endIndex {
                    break
                }

                appendAllowedNonLetterCharacterSequence()
                if index == originalStringView.endIndex {
                    break
                }

                skipAnyNonLetterCharacters()
            }

            resultingIndex = resultingStringView.index(resultingStringView.startIndex, offsetBy: resultingIndexOffset!)
        }

        private typealias Utils = BankCardHolderNameUtils

        private let originalStringView: String.UnicodeScalarView
        private let originalIndex: String.UnicodeScalarIndex

        private var index: String.UnicodeScalarIndex

        private var resultingIndexOffset: Int?

        private mutating func skipAnyNonLetterCharacters() {
            precondition(index != originalStringView.endIndex)

            while (index != originalStringView.endIndex) && !Utils.isLetter(originalStringView[index]) {
                index = originalStringView.index(after: index)
            }

            if (resultingIndexOffset == nil) && (originalIndex <= index) {
                resultingIndexOffset = resultingStringView.count
            }
        }

        private mutating func appendLetterCharacters() {
            precondition(index != originalStringView.endIndex)
            precondition(Utils.isLetter(originalStringView[index]))

            repeat {
                appendCharacter()
            } while (index != originalStringView.endIndex) && Utils.isLetter(originalStringView[index])

            if (resultingIndexOffset == nil) && (originalIndex <= index) {
                resultingIndexOffset = resultingStringView.count - originalStringView.distance(from: originalIndex, to: index)
            }
        }

        private mutating func appendAllowedNonLetterCharacterSequence() {
            precondition(index != originalStringView.endIndex)
            precondition(!Utils.isLetter(originalStringView[index]))

            // Copy " ", ". ", "- ".
            let firstNonLetterCharacter = originalStringView[index]
            appendCharacter()

            if (index != originalStringView.endIndex)
                && (firstNonLetterCharacter != UnicodeScalar(" "))
                && (originalStringView[index] == UnicodeScalar(" ")) {

                appendCharacter()
            }

            if (resultingIndexOffset == nil) && (originalIndex <= index) {
                resultingIndexOffset = resultingStringView.count - originalStringView.distance(from: originalIndex, to: index)
            }
        }

        private mutating func appendCharacter() {
            precondition(index != originalStringView.endIndex)

            resultingStringView.append(originalStringView[index])
            index = originalStringView.index(after: index)
        }
    }

    private static func isLetter(_ unicodeScalar: UnicodeScalar) -> Bool {
        return allowedLetterCharacters.contains(unicodeScalar)
    }

}
