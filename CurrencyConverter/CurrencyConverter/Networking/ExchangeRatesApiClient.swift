//
//  ExchangeRatesApiClient.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 21/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import Alamofire

/// API Client that fetches exchange rates data from `https://api.exchangeratesapi.io`
class ExchangeRatesApiIoClient: ExchangeRatesApiClientProtocol {

    // MARK: - Instance Properties -

    /// The date format used by the API.
    var dateFormat = "yyyy-MM-dd"

    // MARK: - Instance Methods -

    /// Fetches the latest exchange rates.
    /// - Parameters:
    ///   - baseCurrency: The base currency to get the values against.
    ///   - completion: Completion returning `Result<ExchangeRate, Error>`.
    func getLatestExchangeRates(baseCurrency: Currency, completion: @escaping ((Result<ExchangeRate, Error>) -> Void)) {
        let apiUrl = "https://api.exchangeratesapi.io/latest"
        let requestParams: Parameters = ["base" : baseCurrency.currencyCode]
        AF.request(apiUrl, parameters: requestParams).validate()
          .responseDecodable(of: ExchangeRate.self, completionHandler: { (response) in

            if let responseError = response.error {
                completion(.failure(responseError))
                return
            }

            guard let exchangeRates = response.value else {
                completion(.failure(ExchangeRatesApiError.nilResponse))
                return
            }

            completion(.success(exchangeRates))
        })
    }

    /// Fetches the exchange rate history for multiple currencies.
    /// - Parameters:
    ///   - base: The base currency.
    ///   - currencies: The currencies to get the historical data for.
    ///   - startDate: Starting date (from).
    ///   - endDate: End date (to).
    ///   - completion: Completion returning `Result<ExchangeRateHistory, Error>`
    func getExchangeRatesHistory(base: Currency, currencies: [Currency], from startDate: Date, to endDate: Date, completion: @escaping ((Result<ExchangeRateHistory, Error>) -> Void)) {
        let apiUrl = "https://api.exchangeratesapi.io/history"
        let requestParameters: Parameters = [
            "base": base.currencyCode,
            "symbols": currencies.map({ $0.currencyCode }).joined(separator: ","),
            "start_at": startDate.stringRepresentation(format: dateFormat),
            "end_at": endDate.stringRepresentation(format: dateFormat)
        ]

        AF.request(apiUrl, parameters: requestParameters)
            .validate()
            .responseDecodable(of: ExchangeRateHistory.self, completionHandler: { response in
                if let responseError = response.error {
                    completion(.failure(responseError))
                    return
                }

                guard let exchangeRateHistory = response.value else {
                    completion(.failure(ExchangeRatesApiError.nilResponse))
                    return
                }

                completion(.success(exchangeRateHistory))
        })
    }
}
