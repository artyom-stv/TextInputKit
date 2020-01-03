//
//  TestStandardFormattersViewController.swift
//  Example
//
//  Created by Artem Starosvetskiy on 20/11/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Cocoa
import Foundation

final class TestStandardFormattersViewController: TestFormattersViewController {
}

extension TestStandardFormattersViewController {
    override func viewDidLoad() {
        configure()

        super.viewDidLoad()
    }
}

private extension TestStandardFormattersViewController {
    func configure() {
        let items: [TestFormattersViewController.Item] = {
            func item<F: Formatter>(_ formatter: F, comment: String? = nil) -> TestFormattersViewController.Item {
                var title = "NSTextField with \(String(describing: F.self))"
                if let comment = comment {
                    title += " (\(comment))"
                }
                return (
                    title: title,
                    formatter: formatter
                )
            }
            return [
                item(type(of: self).setupNumberFormatter(), comment: "decimal"),
                item(type(of: self).setupDateFormatter(), comment: "short date"),
                item(type(of: self).setupByteCountFormatter()),
                item(type(of: self).setupDateComponentsFormatter()),
                item(type(of: self).setupDateIntervalFormatter()),
                item(type(of: self).setupEnergyFormatter()),
                item(type(of: self).setupLengthFormatter()),
            ]
        }()
        configure(TestFormattersViewController.Configuration(items: items))
    }
}

private extension TestStandardFormattersViewController {
    static func setupNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }

    static func setupDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    static func setupByteCountFormatter() -> ByteCountFormatter {
        let formatter = ByteCountFormatter()
        return formatter
    }

    static func setupDateComponentsFormatter() -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        return formatter
    }

    static func setupDateIntervalFormatter() -> DateIntervalFormatter {
        let formatter = DateIntervalFormatter()
        return formatter
    }

    static func setupEnergyFormatter() -> EnergyFormatter {
        let formatter = EnergyFormatter()
        return formatter
    }

    static func setupLengthFormatter() -> LengthFormatter {
        let formatter = LengthFormatter()
        return formatter
    }

    static func setupMassFormatter() -> MassFormatter {
        let formatter = MassFormatter()
        return formatter
    }
}
