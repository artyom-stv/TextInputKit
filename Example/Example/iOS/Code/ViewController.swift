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

        let maxLength = 6

        textInputBinding = TextInputFormats.plain
            .filter(by: CharacterSet.decimalDigits)
            .filter(constrainingCharactersCount: maxLength)
            .bind(to: textField)
    }

    private var textInputBinding: TextInputBinding<String>!

}
