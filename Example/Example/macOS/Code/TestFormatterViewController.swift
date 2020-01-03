//
//  TestFormatterViewController.swift
//  Example
//
//  Created by Artem Starosvetskiy on 20/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Cocoa
import Foundation

final class TestFormatterViewController: NSViewController {
    struct Configuration {
        let title: String

        let formatter: Formatter
    }

    @IBOutlet private var titleLabel: NSTextField!

    @IBOutlet private var textField: NSTextField!

    @IBOutlet private var valueLabel: NSTextField!

    func configure(_ config: Configuration) {
        self.config = config
    }

    fileprivate var config: Configuration!
}

extension TestFormatterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        guard config != nil else {
            fatalError("\(String(describing: type(of: self))) wasn't configured.")
        }

        titleLabel.stringValue = config.title

        textField.formatter = config.formatter

        updateStringValue()
    }

    override var representedObject: Any? {
        get {
            return textField?.objectValue
        }
        set {
            textField?.objectValue = newValue
        }
    }
}

extension TestFormatterViewController {
    func controlTextDidChange(_ notification: Notification) {
        let control = notification.object as! NSControl
        if control === textField {
            updateStringValue()
        }
    }
}

extension TestFormatterViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, didFailToFormatString string: String, errorDescription error: String?) -> Bool {
        if control === textField {
            // TODO: Implement.
        }
        return true
    }

    func control(_ control: NSControl, didFailToValidatePartialString string: String, errorDescription error: String?) {
        if control === textField {
            // TODO: Implement.
        }
    }
}

private extension TestFormatterViewController {
    func updateStringValue() {
        let stringValue: String

        if let string = config.formatter.string(for: textField.objectValue) {
            stringValue = string
        } else {
            stringValue = ""
        }

        valueLabel.stringValue = stringValue
    }
}
