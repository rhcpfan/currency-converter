//
//  Array-Extension.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 21/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    /// The unique values cotained in the array
    var uniques: Array {
        var buffer = Array()
        self.forEach({
            if !buffer.contains($0) { buffer.append($0) }
        })
        return buffer
    }
}
