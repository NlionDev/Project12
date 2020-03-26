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
            let duration = Double(creditDuration) {
            let rate = doubleRate / 100
            let number = 1 + ( rate / 12 )
            let exponent = (12 * duration)
            result = pow(number, -exponent)
        }
        return result
    }
    
    private func getMensualityWithoutInsurance() -> Double {
        var mensuality = 0.00
        let powerResult = getPowerResult()
        if let doubleAmountToFinance = Double(amountToFinance.replacingOccurrences(of: ",", with: ".")),
            let doubleRate = Double(rate.replacingOccurrences(of: ",", with: ".")) {
            let rate = doubleRate / 100
            let calcul1 = doubleAmountToFinance * (rate / 12)
            let calcul2 = 1 - powerResult
            mensuality = calcul1 / calcul2
        }
        return mensuality
    }
    
    private func getMensualityWithInsurance() -> Double {
        var mensuality = 0.00
        let powerResult = getPowerResult()
        let insuranceCost = getInsuranceCost()
        if let doubleAmountToFinance = Double(amountToFinance.replacingOccurrences(of: ",", with: ".")),
            let doubleRate = Double(rate.replacingOccurrences(of: ",", with: ".")),
            let duration = Double(creditDuration) {
            let mensualInsuranceCost = insuranceCost / (12 * duration)
            let rate = doubleRate / 100
            let calcul1 = doubleAmountToFinance * (rate / 12)
            let calcul2 = 1 - powerResult
            let mensualityWithoutInsurance = calcul1 / calcul2
            mensuality = mensualityWithoutInsurance + mensualInsuranceCost
        }
        return mensuality
    }
    
    private func getInterestCost() -> Double {
        var interestCost = 0.00
        let mensuality = getMensualityWithoutInsurance()
        if let doubleAmountToFinance = Double(amountToFinance.replacingOccurrences(of: ",", with: ".")),
            let duration = Double(creditDuration) {
            interestCost = 12 * duration * mensuality - doubleAmountToFinance
        }
        return interestCost
    }
    
    private func getInsuranceCost() -> Double {
        var insuranceCost = 0.00
        if insuranceRate == "" {
            insuranceCost = 0.00
        } else {
            if let doubleAmountToFinance = Double(amountToFinance.replacingOccurrences(of: ",", with: ".")),
                let doubleInsuranceRate = Double(insuranceRate.replacingOccurrences(of: ",", with: ".")),
                let duration = Double(creditDuration) {
                let calculInsuranceRate = doubleInsuranceRate / 100
                insuranceCost = doubleAmountToFinance * calculInsuranceRate * duration
            }
        }
        return insuranceCost
    }
    
    func getStringMensuality() -> String {
        var finalMensuality = ""
        if insuranceRate == "" {
            let mensualityWithoutInsurance = getMensualityWithoutInsurance()
            let stringMensuality = String(format: "%.02f", mensualityWithoutInsurance)
            if let doubleMensuality = Double(stringMensuality)  {
                finalMensuality = doubleMensuality.clean
            }
        } else {
            let mensualityWithInsurance = getMensualityWithInsurance()
            let stringMensuality = String(format: "%.02f", mensualityWithInsurance)
            if let doubleMensuality = Double(stringMensuality)  {
                finalMensuality = doubleMensuality.clean
            }
        }
        return finalMensuality
    }
    
    func getStringInterestCost() -> String {
        var finalInterestCost = ""
        let interestCost = getInterestCost()
        let stringInterestCost = String(format: "%.02f", interestCost)
        if let doubleInterestCost = Double(stringInterestCost) {
            finalInterestCost = doubleInterestCost.clean
        }
        return finalInterestCost
    }
    
    func getStringInsuranceCost() -> String {
        var finalInsuranceCost = ""
        let insuranceCost = getInsuranceCost()
        let stringInsuranceCost = String(format: "%.02f", insuranceCost)
        if let doubleInsuranceCost = Double(stringInsuranceCost) {
            finalInsuranceCost = doubleInsuranceCost.clean
        }
        return finalInsuranceCost
    }
    
    func getTotalCost() -> String {
        var totalCost = 0.00
        var finalTotalCost = ""
        let insuranceCost = getInsuranceCost()
        let interestCost = getInterestCost()
        if bookingFees == "" {
            if let amountToFinance = Double(amountToFinance.replacingOccurrences(of: ",", with: ".")) {
                totalCost = amountToFinance + insuranceCost + interestCost + 0.00
            }
        } else {
            if let amountToFinance = Double(amountToFinance.replacingOccurrences(of: ",", with: ".")),
                let bookingFees = Double(bookingFees.replacingOccurrences(of: ",", with: ".")) {
                totalCost = amountToFinance + insuranceCost + interestCost + bookingFees
            }
        }
        let stringTotalCost = String(format: "%.02f", totalCost)
        if let doubleTotalCost = Double(stringTotalCost) {
            finalTotalCost = doubleTotalCost.clean
        }
        return finalTotalCost
    }
    
    
}
