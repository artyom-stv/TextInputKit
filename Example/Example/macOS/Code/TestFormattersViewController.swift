//
//  TestFormattersViewController.swift
//  Example
//
//  Created by Artem Starosvetskiy on 20/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation
import Cocoa

class TestFormattersViewController : NSSplitViewController {

    typealias Item = (
        title: String,
        formatter: Formatter
    )

    struct Configuration {

        let items: [Item]

    }

    func configure(_ config: Configuration) {
        self.config = config
    }

    fileprivate var config: Configuration!

}

extension TestFormattersViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.splitViewItems = config.items.map {
            let viewController = storyboard!.instantiateController(TestFormatterViewController.self)
            viewController.configure(TestFormatterViewController.Configuration(title: $0.title, formatter: $0.formatter))
            return NSSplitViewItem(viewController: viewController)
        }
    }

}
