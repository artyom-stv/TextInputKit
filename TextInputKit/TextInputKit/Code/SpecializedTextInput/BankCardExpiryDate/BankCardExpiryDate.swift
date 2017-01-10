//
//  BankCardExpiryDate.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct BankCardExpiryDate {

    public let month: Int

    public let year: Int

    public init(month: Int, year: Int) throws {
        guard month >= 1 && month <= 12 else {
            // TODO: Throw proper error.
            throw TextInputKitError.unknown
        }
        guard year >= 1900 else {
            // TODO: Throw proper error.
            throw TextInputKitError.unknown
        }

        self.init(rawMonth: month, rawYear: year)
    }

    public init(month: Int, lastTwoDigitsOfYear: Int) throws {
        guard month >= 1 && month <= 12 else {
            // TODO: Throw proper error.
            throw TextInputKitError.unknown
        }
        guard lastTwoDigitsOfYear >= 0 && lastTwoDigitsOfYear <= 99 else {
            // TODO: Throw proper error.
            throw TextInputKitError.unknown
        }

        let year = type(of: self).year(fromTwoDigits: lastTwoDigitsOfYear)
        self.init(rawMonth: month, rawYear: year)
    }

    private init(rawMonth: Int, rawYear: Int) {
        self.month = rawMonth
        self.year = rawYear
    }

}

private extension BankCardExpiryDate {

    static func year(fromTwoDigits lastTwoDigitsOfYear: Int) -> Int {
        precondition(lastTwoDigitsOfYear >= 0 && lastTwoDigitsOfYear <= 99)

        // TODO: Find the rule and implement correctly.
        return lastTwoDigitsOfYear >= 67
            ? lastTwoDigitsOfYear + 1900
            : lastTwoDigitsOfYear + 2000
    }

}

extension BankCardExpiryDate {

    static func from(_ dateComponents: DateComponents) throws -> BankCardExpiryDate {
        guard let month = dateComponents.month else {
            // TODO: Throw proper error.
            throw TextInputKitError.unknown
        }
        guard let year = dateComponents.year else {
            // TODO: Throw proper error.
            throw TextInputKitError.unknown
        }
        return try self.init(month: month, year: year)
    }

    static func from(_ date: Date, calendar: Calendar) -> BankCardExpiryDate {
        let dateComponents = calendar.dateComponents([.month, .year], from: date)
        return try! from(dateComponents)
    }

    func toDateComponents() -> DateComponents {
        return DateComponents(year: year, month: month)
    }

    func toDate(using calendar: Calendar) -> Date {
        let dateComponents = toDateComponents()
        return calendar.date(from: dateComponents)!
    }

}

extension BankCardExpiryDate : Equatable {

    public static func ==(lhs: BankCardExpiryDate, rhs: BankCardExpiryDate) -> Bool {
        return (lhs.year == rhs.year) && (lhs.month == rhs.month)
    }

}

extension BankCardExpiryDate : Hashable {

    public var hashValue: Int {
        return (year << 4) | month
    }
    
}
