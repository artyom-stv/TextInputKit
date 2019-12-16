//
//  BankCardExpiryDate.swift
//  TextInputKit
//
//  Created by Artem Starosvetskiy on 22/12/2016.
//  Copyright © 2016 Artem Starosvetskiy. All rights reserved.
//

import Foundation

public struct BankCardExpiryDate {

    /// An error thrown by `BankCardExpiryDate` initializers.
    ///
    /// - invalidMonth: The provided integer doesn't represent a valid month.
    /// - invalidYear: The provided integer doesn't represent a valid year.
    public enum InitializationError : Error {

        case invalidMonth

        case invalidYear

    }

    /// The expiration date month.
    public let month: Int

    /// The expiration date year.
    public let year: Int

    /// Creates a `BankCardExpiryDate` using a month and a year.
    ///
    /// - Parameters:
    ///   - month: The expiration date month.
    ///   - year: The expiration date year.
    /// - Throws:
    ///   - `InitializationError.invalidMonth` if the provided integer doesn't represent a valid month
    ///     (doesn't fit 1...12).
    ///   - `InitializationError.invalidYear` if the provided integer doesn't represent a valid year.
    public init(month: Int, year: Int) throws {
        guard month >= 1 && month <= 12 else {
            throw InitializationError.invalidMonth
        }
        guard year >= 1900 else {
            throw InitializationError.invalidYear
        }

        self.init(rawMonth: month, rawYear: year)
    }

    /// Creates a `BankCardExpiryDate` using a month and the last two digits of a year.
    ///
    /// - Parameters:
    ///   - month: The expiration date month.
    ///   - lastTwoDigitsOfYear: The last two ditis of the expiration date year.
    ///   - `InitializationError.invalidMonth` if the provided integer doesn't represent a valid month
    ///     (doesn't fit 1...12).
    ///   - `InitializationError.invalidYear` if the provided integer doesn't represent a valid year
    ///     (doesn't fit 0...99).
    public init(month: Int, lastTwoDigitsOfYear: Int) throws {
        guard month >= 1 && month <= 12 else {
            throw InitializationError.invalidMonth
        }
        guard lastTwoDigitsOfYear >= 0 && lastTwoDigitsOfYear <= 99 else {
            throw InitializationError.invalidYear
        }

        let year = type(of: self).year(fromTwoDigits: lastTwoDigitsOfYear)
        self.init(rawMonth: month, rawYear: year)
    }

    private init(rawMonth: Int, rawYear: Int) {
        self.month = rawMonth
        self.year = rawYear
    }

}

extension BankCardExpiryDate.InitializationError : CustomStringConvertible {

    public var description: String {
        switch self {
        case .invalidMonth:
            return "The provided integer doesn't represent a valid month."

        case .invalidYear:
            return "The provided integer doesn't represent a valid year."
        }
    }
    
}

private extension BankCardExpiryDate {

    static func year(fromTwoDigits lastTwoDigitsOfYear: Int) -> Int {
        assert(lastTwoDigitsOfYear >= 0 && lastTwoDigitsOfYear <= 99)

        // TODO: Find the rule and implement correctly.
        // The reason to use a magic number 67: the first bank card was issued in 1967.
        return lastTwoDigitsOfYear >= 67
            ? lastTwoDigitsOfYear + 1900
            : lastTwoDigitsOfYear + 2000
    }

}

extension BankCardExpiryDate {

    /// An error thrown by `BankCardExpiryDate` factory methods.
    ///
    /// - missingMonth: The provided `DateComponents` should have non-nil `month`.
    /// - missingYear: The provided `DateComponents` should have non-nil `year`.
    public enum FactoryMethodError : Error {

        case missingMonth

        case missingYear

    }

    /// Creates a `BankCardExpiryDate` using `DateComponents` `month` and `year`.
    ///
    /// - Parameters:
    ///   - dateComponents: The `DateComponents`.
    /// - Returns: The created `BankCardExpiryDate`.
    /// - Throws:
    ///   - `FactoryMethodError.missingMonth` if `month` in `DateComponents` is nil.
    ///   - `FactoryMethodError.missingYear` if `year` in `DateComponents` is nil.
    public static func from(_ dateComponents: DateComponents) throws -> BankCardExpiryDate {
        guard let month = dateComponents.month else {
            throw FactoryMethodError.missingMonth
        }
        guard let year = dateComponents.year else {
            throw FactoryMethodError.missingYear
        }
        return try self.init(month: month, year: year)
    }

    /// Creates a `BankCardExpiryDate` using a `Date` and a `Calendar`.
    ///
    /// - Parameters:
    ///   - date: The `Date`.
    ///   - calendar: The `Calendar` which is used to extract `DateComponents` from the `Date`.
    /// - Returns: The created `BankCardExpiryDate`.
    public static func from(_ date: Date, calendar: Calendar) -> BankCardExpiryDate {
        let dateComponents = calendar.dateComponents([.month, .year], from: date)
        return try! from(dateComponents)
    }

    /// Creates `DateComponents` corresponding to the `BankCardExpiryDate`.
    ///
    /// - Returns: The created `DateComponents`.
    public func toDateComponents() -> DateComponents {
        return DateComponents(year: year, month: month)
    }

    /// Creates a `Date` corresponding to the `BankCardExpiryDate`.
    ///
    /// - Parameters:
    ///   - calendar: The `Calendar` which is used to create a `Date` from `DateComponents`.
    /// - Returns: The created `Date`.
    public func toDate(using calendar: Calendar) -> Date {
        let dateComponents = toDateComponents()
        return calendar.date(from: dateComponents)!
    }

}

extension BankCardExpiryDate.FactoryMethodError : CustomStringConvertible {

    public var description: String {
        switch self {
        case .missingMonth:
            return "The provided `DateComponents` should have non-nil `month`."

        case .missingYear:
            return "The provided `DateComponents` should have non-nil `year`."
        }
    }
    
}

extension BankCardExpiryDate : Equatable {

    public static func ==(lhs: BankCardExpiryDate, rhs: BankCardExpiryDate) -> Bool {
        return (lhs.year == rhs.year) && (lhs.month == rhs.month)
    }

}

extension BankCardExpiryDate : Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
    }
    
}
