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
    var powerResult = Double()
    var mensualityWithoutInsurance = Double()
    var mensualityWithInsurance = Double()
    var insuranceCost = Double()
    var interestCost = Double()
    
    //MARK: - Enum
    enum CreditCalculatorError: Error {
        case amountToFinanceMissing
        case rateMissing
    }
    
    //MARK: - Private Methods
    private func getPowerResult() throws -> Double {
        var result = Double()
        if let rate = creditData["Taux"],
            let creditDuration = creditData["Durée"] {
            if rate == "" {
                throw CreditCalculatorError.rateMissing
            } else {
                let doubleRate = rate.transformInDouble
                let duration = creditDuration.transformInDouble
                let rate = doubleRate / 100
                let number = 1 + ( rate / 12 )
                let exponent = (12 * duration)
                result = pow(number, -exponent)
            }
        }
        return result
    }
    
    private func getMensualityWithoutInsurance() throws -> Double {
        do {
            powerResult = try getPowerResult()
        } catch let error as CreditCalculator.CreditCalculatorError {
            throw error
        }
        var mensuality = Double()
        if let amountToFinance = creditData["Montant à financer"],
            let rate = creditData["Taux"] {
            if amountToFinance == "" {
                throw CreditCalculatorError.amountToFinanceMissing
            } else if rate == "" {
                throw CreditCalculatorError.rateMissing
            } else {
                let doubleAmountToFinance = amountToFinance.transformInDouble
                let doubleRate = rate.transformInDouble
                let rate = doubleRate / 100
                let calcul1 = doubleAmountToFinance * (rate / 12)
                let calcul2 = 1 - powerResult
                mensuality = calcul1 / calcul2
            }
        }
        return mensuality
    }
    
    private func getMensualityWithInsurance() throws -> Double {
        do {
            powerResult = try getPowerResult()
            insuranceCost = try getInsuranceCost()
        } catch let error as CreditCalculator.CreditCalculatorError {
            throw error
        }
        var mensuality = Double()
        if let amountToFinance = creditData["Montant à financer"],
            let rate = creditData["Taux"],
            let creditDuration = creditData["Durée"] {
            if amountToFinance == "" {
                throw CreditCalculatorError.amountToFinanceMissing
            } else if rate == "" {
                throw CreditCalculatorError.rateMissing
            } else {
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
        }
        return mensuality
    }
    
    private func getInterestCost() throws -> Double {
        do {
            mensualityWithoutInsurance = try getMensualityWithoutInsurance()
        } catch let error as CreditCalculator.CreditCalculatorError {
            throw error
        }
        var interestCost = Double()
        if let amountToFinance = creditData["Montant à financer"],
            let creditDuration = creditData["Durée"] {
            if amountToFinance == "" {
                throw CreditCalculatorError.amountToFinanceMissing
            } else {
                let doubleAmountToFinance = amountToFinance.transformInDouble
                let duration = creditDuration.transformInDouble
                interestCost = 12 * duration * mensualityWithoutInsurance - doubleAmountToFinance
            }
        }
        return interestCost
    }
    
    private func getInsuranceCost() throws -> Double {
        var insuranceCost = Double()
        if let insuranceRate = creditData["Taux assurance"],
            let amountToFinance = creditData["Montant à financer"],
            let creditDuration = creditData["Durée"] {
            if amountToFinance == "" {
                throw CreditCalculatorError.amountToFinanceMissing
            } else {
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
        }
        return insuranceCost
    }
    
    //MARK: - Public Methods
    func getStringMensuality() throws -> String {
        do {
            mensualityWithoutInsurance = try getMensualityWithoutInsurance()
            mensualityWithInsurance = try getMensualityWithInsurance()
        } catch let error as CreditCalculator.CreditCalculatorError {
            throw error
        }
        var finalMensuality = String()
        if let insuranceRate = creditData["Taux assurance"] {
            if insuranceRate == "" {
                let stringMensuality = mensualityWithoutInsurance.formatIntoStringWithTwoNumbersAfterPoint
                let doubleMensuality = stringMensuality.transformInDouble
                finalMensuality = doubleMensuality.clean
            } else {
                let stringMensuality = mensualityWithInsurance.formatIntoStringWithTwoNumbersAfterPoint
                let doubleMensuality = stringMensuality.transformInDouble
                finalMensuality = doubleMensuality.clean
            }
        }
        return finalMensuality
    }
    
    func getStringInterestCost() throws -> String {
        do {
            interestCost = try getInterestCost()
        } catch let error as CreditCalculator.CreditCalculatorError {
            throw error
        }
        let stringInterestCost = interestCost.formatIntoStringWithTwoNumbersAfterPoint
        let doubleInterestCost = stringInterestCost.transformInDouble
        let finalInterestCost = doubleInterestCost.clean
        return finalInterestCost
    }
    
    func getStringInsuranceCost() throws -> String {
        do {
            insuranceCost = try getInsuranceCost()
        } catch let error as CreditCalculator.CreditCalculatorError {
            throw error
        }
        let stringInsuranceCost = insuranceCost.formatIntoStringWithTwoNumbersAfterPoint
        let doubleInsuranceCost = stringInsuranceCost.transformInDouble
        let finalInsuranceCost = doubleInsuranceCost.clean
        return finalInsuranceCost
    }
    
    func getTotalCost() throws -> String {
        do {
            insuranceCost = try getInsuranceCost()
            interestCost = try getInterestCost()
        } catch let error as CreditCalculator.CreditCalculatorError {
            throw error
        }
        var totalCost = Double()
        var finalTotalCost = String()
        if let bookingFees = creditData["Frais de dossier"],
            let amountToFinance = creditData["Montant à financer"] {
            if amountToFinance == "" {
                throw CreditCalculatorError.amountToFinanceMissing
            } else {
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
        }
        return finalTotalCost
    }
}
