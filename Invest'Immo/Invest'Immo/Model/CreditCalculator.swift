//
//  CreditCalculator.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 25/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

class CreditCalculator {
    
    //MARK: - Properties
    
    var amountToFinance = ""
    var creditDuration = ""
    var rate = ""
    var insuranceRate = ""
    var bookingFees = ""
    
    //MARK: - Enum
    
    enum CreditCalculatorError: Error {
        case amountToFinanceMissing
        case creditDurationMissing
        case rateMissing
    }
    
    //MARK: - Methods
    
    private func getPowerResult() -> Double {
        var result = 0.00
        if let doubleRate = Double(rate.replacingOccurrences(of: ",", with: ".")),
            let intDuration = Int(creditDuration) {
            let number = 1 + doubleRate / 12
            let exposant = -12 * intDuration
            for _ in 1 ... exposant {
                result = number * number
            }
        }
        return result
    }
    
    func getMensuality() -> String {
        var mensuality = 0.00
        var finalMensuality = ""
        let powerResult = getPowerResult()
        if let doubleAmountToFinance = Double(amountToFinance.replacingOccurrences(of: ",", with: ".")),
            let doubleRate = Double(rate.replacingOccurrences(of: ",", with: ".")) {
            mensuality = (doubleAmountToFinance * (doubleRate / 12)) / 1 - powerResult
        }
        let stringMensuality = String(format: "%.02f", mensuality)
        if let doubleMensuality = Double(stringMensuality)  {
            finalMensuality = doubleMensuality.clean
        }
        return finalMensuality
    }
    
    
}
