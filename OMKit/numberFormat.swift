//
//  numberFormat.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/19/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import Foundation
// receives a double and converts it to just 3 decimal places, returns a string for use in UILabel/button/etc.
func formatMathSolution(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 3
    let result = formatter.string(from: value as NSNumber)
    return result!
}

// receives a double and converts it to a currency format (USD)
func formatCurrencyUSD(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: Locale.current.identifier)
    let result = formatter.string(from: value as NSNumber)
    return result!
}

func formatCurrencyEUR(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: "fr_MC")
    let result = formatter.string(from: value as NSNumber)
    return result!
    
}

func formatCurrencyBTC(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 5
    formatter.currencySymbol = ""
    var result = formatter.string(from: value as NSNumber)
    result = "Ƀ" + result!
    return result!
    
}
