//
//  ViewController.swift
//  Example-iOS
//
//  Created by Artem Starosvetskiy on 19/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import UIKit
import TextInputKit

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = TextInputFormats.plain
        _ = TextInputFormats.bankCardNumber(.options())
        _ = TextInputFormats.phoneNumber(.options())

        let maxLength = 6

        let driver = TextInputFormats.plain
            .filter(by: CharacterSet.decimalDigits)
            .filter(constrainingCharactersCount: maxLength)
//            .transformValue<Int>(direct: { Int($0) }, reverse: { String(describing: $0) })
            .bind(to: textField)
        textFieldDriver = driver
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private var textFieldDriver: TextInputDriver<String>!

}
