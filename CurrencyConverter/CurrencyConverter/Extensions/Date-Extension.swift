//
//  Date-Extension.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation

extension Date {

    /// Creates a `Date` instance from a string, given the date format.
    /// - Parameters:
    ///   - format: The date format.
    ///   - value: The date represented as string.
    /// - Returns: The `Date` instance if parsing succedes, `nil` otherwise.
    init?(format: String, value: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let parsedDate = dateFormatter.date(from: value) {
            self = parsedDate
        } else {
            return nil
        }
    }


    /// Creates a string representation from the date instance.
    /// - Parameters:
    ///   - dateStyle: The date style (long, medium, etc.)
    ///   - timeStyle: The time style (long, medium, etc.)
    func stringRepresentation(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }

    /// Creates a string representation from the date instance.
    /// - Parameters:
    ///   - format: The date format.
    func stringRepresentation(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    /// Returns a `Date` by subtracting an amount of days.
    /// - Parameter days: The number of days to subtract.
    func dateBySubtracting(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days * -1, to: self)
    }
}
