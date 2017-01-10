//
//  ViewController.swift
//  Example-iOS
//
//  Created by Artem Starosvetskiy on 19/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import UIKit
import TextInputKit

class TestFormatterViewController: UIViewController {

    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        textInputBinding = TextInputFormats.plain
            .bind(to: textField)
    }

    private var textInputBinding: TextInputBinding<String>!

}
