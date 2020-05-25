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
    var creditData = [CreditItem.amountToFinance.titles: emptyString, CreditItem.duration.titles: emptyString, CreditItem.rate.titles: emptyString, CreditItem.insuranceRate.titles: emptyString, CreditItem.bookingFees.titles: emptyString]
    var powerResult = Double()
    var mensualityWithoutInsurance = Double()
    var mensualityWithInsurance = Double()
    var insuranceCost = Double()
    var interestCost = Double()
    
    //MARK: - Enum
    enum CreditCalculatorError: Error {
        case amountToFinanceMissing
        case rateMissing
        case unknowError
        
        var message: String {
            switch self {
            case .amountToFinanceMissing:
                return "Le montant à financer n'est pas renseigné"
            case .rateMissing:
                return "Le taux n'est pas renseigné"
            case .unknowError:
                return "Une erreur inconnue s'est produite"
            }
        }
    }
    
    //MARK: - Private Methods
    private func getPowerResult() throws -> Double {
        var result = Double()
        if let rate = creditData[CreditItem.rate.titles],
            let creditDuration = creditData[CreditItem.duration.titles] {
            if rate == emptyString {
                throw CreditCalculatorError.rateMissing
            } else {
                let doubleRate = rate.transformInDouble
                let duration = creditDuration.transformInDouble
                let rate = doubleRate / hundred
                let number = one + ( rate / numberOfMonths )
                let exponent = (numberOfMonths * duration)
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
        if let amountToFinance = creditData[CreditItem.amountToFinance.titles],
            let rate = creditData[CreditItem.rate.titles] {
            let doubleAmountToFinance = amountToFinance.transformInDouble
            let doubleRate = rate.transformInDouble
            let rate = doubleRate / hundred
            let calcul1 = doubleAmountToFinance * (rate / numberOfMonths)
            let calcul2 = one - powerResult
            mensuality = calcul1 / calcul2
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
        if let amountToFinance = creditData[CreditItem.amountToFinance.titles],
            let rate = creditData[CreditItem.rate.titles],
            let creditDuration = creditData[CreditItem.duration.titles] {
            let doubleAmountToFinance = amountToFinance.transformInDouble
            let doubleRate = rate.transformInDouble
            let duration = creditDuration.transformInDouble
            let mensualInsuranceCost = insuranceCost / (numberOfMonths * duration)
            let rate = doubleRate / hundred
            let calcul1 = doubleAmountToFinance * (rate / numberOfMonths)
            let calcul2 = one - powerResult
            let mensualityWithoutInsurance = calcul1 / calcul2
            mensuality = mensualityWithoutInsurance + mensualInsuranceCost
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
        if let amountToFinance = creditData[CreditItem.amountToFinance.titles],
            let creditDuration = creditData[CreditItem.duration.titles] {
            let doubleAmountToFinance = amountToFinance.transformInDouble
            let duration = creditDuration.transformInDouble
            interestCost = numberOfMonths * duration * mensualityWithoutInsurance - doubleAmountToFinance
        }
        return interestCost
    }
    
    private func getInsuranceCost() throws -> Double {
        var insuranceCost = Double()
        if let insuranceRate = creditData[CreditItem.insuranceRate.titles],
            let amountToFinance = creditData[CreditItem.amountToFinance.titles],
            let creditDuration = creditData[CreditItem.duration.titles] {
            if amountToFinance == emptyString {
                throw CreditCalculatorError.amountToFinanceMissing
            } else {
                if insuranceRate == emptyString {
                    insuranceCost = zero
                } else {
                    let doubleAmountToFinance = amountToFinance.transformInDouble
                    let doubleInsuranceRate = insuranceRate.transformInDouble
                    let duration = creditDuration.transformInDouble
                    let calculInsuranceRate = doubleInsuranceRate / hundred
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
        if let insuranceRate = creditData[CreditItem.insuranceRate.titles] {
            if insuranceRate == emptyString {
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
        if let bookingFees = creditData[CreditItem.bookingFees.titles],
            let amountToFinance = creditData[CreditItem.amountToFinance.titles] {
            if bookingFees == emptyString {
                let amount = amountToFinance.transformInDouble
                totalCost = amount + insuranceCost + interestCost + zero
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
