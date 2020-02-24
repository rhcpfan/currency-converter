//
//  ExchangeRatesApiClientProtocol.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 24/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import Alamofire

enum ExchangeRatesApiError: Error {
    case nilResponse
    case invalidCurrencyCode
    case decodeTimestampError
}

/// Protocol used to describe the networking layer.
protocol ExchangeRatesApiClientProtocol {

    // MARK: - Instance Properties -

    /// Returns `true` if the device is connected to the internet.
    var isConnectedToInternet: Bool { get }

    // MARK: - Instance Methods -

    func getLatestExchangeRates(baseCurrency: Currency, completion: @escaping ((Result<ExchangeRate, Error>) -> Void))
    func getExchangeRatesHistory(base: Currency, currencies: [Currency], from startDate: Date, to endDate: Date, completion: @escaping ((Result<ExchangeRateHistory, Error>) -> Void))
}

extension ExchangeRatesApiClientProtocol {
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
