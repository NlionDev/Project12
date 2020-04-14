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
    
    var creditData = ["Montant à financer": "", "Durée": "", "Taux": "", "Taux assurance": "", "Frais de dossier": ""]

    
    //MARK: - Enum
    
    enum CreditCalculatorError: Error {
        case amountToFinanceMissing
        case creditDurationMissing
        case rateMissing
    }
    
    //MARK: - Methods
    
    private func getPowerResult() -> Double {
        var result = Double()
        if let rate = creditData["Taux"],
            let creditDuration = creditData["Durée"] {
            let doubleRate = rate.transformInDouble
            let duration = creditDuration.transformInDouble
            let rate = doubleRate / 100
            let number = 1 + ( rate / 12 )
            let exponent = (12 * duration)
            result = pow(number, -exponent)
        }
        return result
    }
    
    private func getMensualityWithoutInsurance() -> Double {
        let powerResult = getPowerResult()
        var mensuality = Double()
        if let amountToFinance = creditData["Montant à financer"],
            let rate = creditData["Taux"] {
            let doubleAmountToFinance = amountToFinance.transformInDouble
            let doubleRate = rate.transformInDouble
            let rate = doubleRate / 100
            let calcul1 = doubleAmountToFinance * (rate / 12)
            let calcul2 = 1 - powerResult
            mensuality = calcul1 / calcul2
        }
        return mensuality
    }
    
    private func getMensualityWithInsurance() -> Double {
        let powerResult = getPowerResult()
        let insuranceCost = getInsuranceCost()
        var mensuality = Double()
        if let amountToFinance = creditData["Montant à financer"],
            let rate = creditData["Taux"],
            let creditDuration = creditData["Durée"] {
            let doubleAmountToFinance = amountToFinance.transformInDouble
            let doubleRate = rate.transformInDouble
            let duration = creditDuration.transformInDouble
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
        let mensuality = getMensualityWithoutInsurance()
        var interestCost = Double()
        if let amountToFinance = creditData["Montant à financer"],
            let creditDuration = creditData["Durée"] {
            let doubleAmountToFinance = amountToFinance.transformInDouble
            let duration = creditDuration.transformInDouble
            interestCost = 12 * duration * mensuality - doubleAmountToFinance
        }
        return interestCost
    }
    
    private func getInsuranceCost() -> Double {
        var insuranceCost = Double()
        if let insuranceRate = creditData["Taux assurance"],
            let amountToFinance = creditData["Montant à financer"],
            let creditDuration = creditData["Durée"] {
            if insuranceRate == "" {
                insuranceCost = 0.00
            } else {
                let doubleAmountToFinance = amountToFinance.transformInDouble
                let doubleInsuranceRate = insuranceRate.transformInDouble
                let duration = creditDuration.transformInDouble
                let calculInsuranceRate = doubleInsuranceRate / 100
                insuranceCost = doubleAmountToFinance * calculInsuranceRate * duration
            }
        }
        return insuranceCost
    }
    
    func getStringMensuality() -> String {
        var finalMensuality = String()
        if let insuranceRate = creditData["Taux assurance"] {
            if insuranceRate == "" {
                let mensualityWithoutInsurance = getMensualityWithoutInsurance()
                let stringMensuality = mensualityWithoutInsurance.formatIntoStringWithTwoNumbersAfterPoint
                let doubleMensuality = stringMensuality.transformInDouble
                finalMensuality = doubleMensuality.clean
            } else {
                let mensualityWithInsurance = getMensualityWithInsurance()
                let stringMensuality = mensualityWithInsurance.formatIntoStringWithTwoNumbersAfterPoint
                let doubleMensuality = stringMensuality.transformInDouble
                finalMensuality = doubleMensuality.clean
            }
        }
        return finalMensuality
    }
    
    func getStringInterestCost() -> String {
        let interestCost = getInterestCost()
        let stringInterestCost = interestCost.formatIntoStringWithTwoNumbersAfterPoint
        let doubleInterestCost = stringInterestCost.transformInDouble
        let finalInterestCost = doubleInterestCost.clean
        return finalInterestCost
    }
    
    func getStringInsuranceCost() -> String {
        let insuranceCost = getInsuranceCost()
        let stringInsuranceCost = insuranceCost.formatIntoStringWithTwoNumbersAfterPoint
        let doubleInsuranceCost = stringInsuranceCost.transformInDouble
        let finalInsuranceCost = doubleInsuranceCost.clean
        return finalInsuranceCost
    }
    
    func getTotalCost() -> String {
        var totalCost = Double()
        var finalTotalCost = String()
        let insuranceCost = getInsuranceCost()
        let interestCost = getInterestCost()
        if let bookingFees = creditData["Frais de dossier"],
            let amountToFinance = creditData["Montant à financer"] {
            if bookingFees == "" {
                let amount = amountToFinance.transformInDouble
                totalCost = amount + insuranceCost + interestCost + 0.00
            } else {
                let amount = amountToFinance.transformInDouble
                let doubleBookingFees = bookingFees.transformInDouble
                totalCost = amount + insuranceCost + interestCost + doubleBookingFees
            }
            let stringTotalCost = totalCost.formatIntoStringWithTwoNumbersAfterPoint
            let doubleTotalCost = stringTotalCost.transformInDouble
            finalTotalCost = doubleTotalCost.clean
        }
        return finalTotalCost
    }
}
