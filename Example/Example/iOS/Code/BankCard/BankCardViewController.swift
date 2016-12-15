//
//  BankCardViewController.swift
//  Example
//
//  Created by Artem Starosvetskiy on 15/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import UIKit
import TextInputKit

final class BankCardViewController : UIViewController {

    @IBOutlet var cardNumberTextField: UITextField!

    @IBOutlet var cardExpiryDateTextField: UITextField!

    @IBOutlet var cardHolderNameTextField: UITextField!

    @IBOutlet var cardSecurityCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTextInputFormats()
        bindTextInputChangesHandler()
    }

    fileprivate var cardNumberTextInputBinding: TextInputDriver<BankCardNumber>!

    fileprivate var cardExpiryDateTextInputBinding: TextInputDriver<DateComponents>!

    fileprivate var cardHolderNameTextInputBinding: TextInputDriver<String>!

    fileprivate var cardSecurityCodeTextInputBinding: TextInputDriver<String>!

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

    private var cardExpiryDateTextInputFormat: TextInputFormat<DateComponents> {
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

    func bindTextInputChangesHandler() {
        // TODO: Implement.
    }

}
