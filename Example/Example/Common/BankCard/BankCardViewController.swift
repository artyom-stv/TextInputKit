//
//  BankCardViewController.swift
//  Example
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

import TextInputKit

struct BankCard {

    var cardNumber: BankCardNumber?

    var expiryDate: BankCardExpiryDate?

    var cardHolderName: String = ""

    var securityCode: String = ""

}

extension BankCard {

    var prettyDescription: String {
        let cardNumberDescription: String = {
            if let cardNumber = cardNumber {
                var description = "{ digitsString: \"\(cardNumber.digitsString)\""
                if let cardBrand = cardNumber.cardBrand {
                    description += ", cardBrand: \(cardBrand)"
                }
                description += " }"
                return description
            }
            return "nil"
        }()
        let expiryDateDescription: String = {
            if let expiryDate = expiryDate {
                return "{ month: \(expiryDate.month), year: \(expiryDate.year) }"
            }
            return "nil"
        }()

        return ""
            + "{\n"
            + "  cardNumber: \(cardNumberDescription),\n"
            + "  expiryDate: \(expiryDateDescription),\n"
            + "  cardHolderName: \"\(cardHolderName)\",\n"
            + "  securityCode: \"\(securityCode)\"\n"
            + "}"
    }

}

final class BankCardViewController: ViewController {

    @IBOutlet private var cardNumberTextField: TextField!

    @IBOutlet private var cardExpiryDateTextField: TextField!

    @IBOutlet private var cardHolderNameTextField: TextField!

    @IBOutlet private var cardSecurityCodeTextField: TextField!

    #if os(macOS)
    @IBOutlet private var descriptionLabel: NSTextField!
    #else
    @IBOutlet private var descriptionLabel: UILabel!
    #endif

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTextInputFormats()
        bindTextInputEventHandlers()

        updateDescriptionText()
    }

    fileprivate var bankCard: BankCard = BankCard()

    fileprivate var cardNumberTextInputBinding: TextInputBinding<BankCardNumber>!

    fileprivate var cardExpiryDateTextInputBinding: TextInputBinding<BankCardExpiryDate>!

    fileprivate var cardHolderNameTextInputBinding: TextInputBinding<String>!

    fileprivate var cardSecurityCodeTextInputBinding: TextInputBinding<String>!

}

private extension BankCardViewController {

    func bindTextInputFormats() {
        cardNumberTextInputBinding = cardNumberTextInputFormat.bind(to: cardNumberTextField)
        cardExpiryDateTextInputBinding = cardExpiryDateTextInputFormat.bind(to: cardExpiryDateTextField)
        cardHolderNameTextInputBinding = cardHolderNameTextInputFormat.bind(to: cardHolderNameTextField)
        cardSecurityCodeTextInputBinding = cardSecurityCodeTextInputFormat.bind(to: cardSecurityCodeTextField)
    }

    private var cardNumberTextInputFormat: TextInputFormat<BankCardNumber> {
        return TextInputFormats.bankCardNumber()
    }

    private var cardExpiryDateTextInputFormat: TextInputFormat<BankCardExpiryDate> {
        return TextInputFormats.bankCardExpiryDate()
    }

    private var cardHolderNameTextInputFormat: TextInputFormat<String> {
        return TextInputFormats.bankCardHolderName()
    }

    private var cardSecurityCodeTextInputFormat: TextInputFormat<String> {
        let allowedCharacters = CharacterSet.decimalDigits
        let maxLength = 4

        return TextInputFormats.plain
            .filter(by: allowedCharacters)
            .filter(constrainingCharactersCount: maxLength)
    }

}

private extension BankCardViewController {

    func bindTextInputEventHandlers() {
        cardNumberTextInputBinding.eventHandler = { [unowned self] event in
            switch event {
            case let .editingChanged(state, changes):
                if changes.contains(.value) {
                    self.bankCard.cardNumber = state.value
                    self.updateDescriptionText()
                }
            default:
                break
            }
        }
        cardExpiryDateTextInputBinding.eventHandler = { [unowned self] event in
            switch event {
            case let .editingChanged(state, changes):
                if changes.contains(.value) {
                    self.bankCard.expiryDate = state.value
                    self.updateDescriptionText()
                }
            default:
                break
            }
        }
        cardHolderNameTextInputBinding.eventHandler = { [unowned self] event in
            switch event {
            case let .editingChanged(state, changes):
                if changes.contains(.value) {
                    self.bankCard.cardHolderName = state.value ?? ""
                    self.updateDescriptionText()
                }
            default:
                break
            }
        }
        cardSecurityCodeTextInputBinding.eventHandler = { [unowned self] event in
            switch event {
            case let .editingChanged(state, changes):
                if changes.contains(.value) {
                    self.bankCard.securityCode = state.value ?? ""
                    self.updateDescriptionText()
                }
            default:
                break
            }
        }
    }

}

private extension BankCardViewController {

    func updateDescriptionText() {
        #if os(macOS)
        descriptionLabel.stringValue = bankCard.prettyDescription
        #else
        descriptionLabel.text = bankCard.prettyDescription
        #endif
    }

}
