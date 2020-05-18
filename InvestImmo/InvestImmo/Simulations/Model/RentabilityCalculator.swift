//
//  RentabilityCalculator.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 24/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

class RentabilityCalculator {
    
    //MARK: - Properties
    var rentabilityData = ["Prix du bien": "", "Coût des travaux": "", "Frais de notaire": "", "Loyer mensuel": "", "Taxe foncière": "", "Frais d'entretien": "", "Charges de copropriété": "", "Frais de gérance": "", "Assurance loyers impayés": "", "Coût du crédit": ""]
    var annualRent = Double()
    var annualTotalCharges = Double()
    var annualManagementFeesAmount = Double()
    var totalToFinance = Double()
    
    //MARK: - Enum
    enum RentabilityCalculatorError: Error {
        case estatePriceMissing
        case notaryFeesMissing
        case monthlyRentMissing
        case propertyTaxMissing
        case chargesMissing
        case unknowError
        
        var message: String {
            switch self {
            case .estatePriceMissing:
                return "Le prix du bien n'est pas renseigné"
            case .notaryFeesMissing:
                return "Les frais de notaire ne sont pas renseignés"
            case .monthlyRentMissing:
                return "Le loyer mensuel n'est pas renseigné"
            case .propertyTaxMissing:
                return "La taxe foncière n'est pas renseignée"
            case .chargesMissing:
                return "Les charges de copropriété ne sont pas renseignées"
            case .unknowError:
                return "Une erreur inconnue s'est produite"
            }
        }
    }
    
    //MARK: - Private Methods
    private func getAnnualRent() throws -> Double {
        var annualRent = Double()
        if let monthlyRent = rentabilityData[RentabilityItem.monthlyRent.titles] {
            if monthlyRent == emptyString {
                throw RentabilityCalculatorError.monthlyRentMissing
            } else {
                let doubleMonthlyRent = monthlyRent.transformInDouble
                annualRent = doubleMonthlyRent * numberOfMonths
            }
        }
        return annualRent
    }
    
    private func getAnnualManagementFeesAmount() -> Double {
        var annualManagementFeesAmount = Double()
        if let managementFees = rentabilityData[RentabilityItem.managementFees.titles],
            let monthlyRent = rentabilityData[RentabilityItem.monthlyRent.titles] {
            if managementFees == emptyString {
                annualManagementFeesAmount = zero
            } else {
                let doubleMonthlyRent = monthlyRent.transformInDouble
                let doubleManagementFees = managementFees.transformInDouble
                let managementFeesAmount = doubleMonthlyRent * doubleManagementFees / hundred
                annualManagementFeesAmount = managementFeesAmount * numberOfMonths
            }
        }
        return annualManagementFeesAmount
    }
    
    private func getAnnualInsuranceCost() -> Double {
        var annualInsuranceCost = Double()
        if let insurance = rentabilityData[RentabilityItem.insurance.titles] {
            if insurance == emptyString {
                annualInsuranceCost = zero
            } else {
                let doubleInsurance = insurance.transformInDouble
                annualInsuranceCost = doubleInsurance * numberOfMonths
            }
        }
        return annualInsuranceCost
    }
    
    private func getAnnualCreditCost() -> Double {
        var annualCreditCost = Double()
        if let creditCost = rentabilityData[RentabilityItem.creditCost.titles] {
            if creditCost == emptyString {
                annualCreditCost = zero
            } else {
                let doubleCreditCost = creditCost.transformInDouble
                annualCreditCost = doubleCreditCost * numberOfMonths
            }
        }
        return annualCreditCost
    }
    
    private func getTotalToFinance() throws -> Double {
        var totalToFinance = Double()
        if let worksPrice = rentabilityData[RentabilityItem.worksCost.titles],
            let estatePrice = rentabilityData[RentabilityItem.estatePrice.titles],
            let notaryFees = rentabilityData[RentabilityItem.notaryFees.titles] {
            if estatePrice == emptyString {
                throw RentabilityCalculatorError.estatePriceMissing
            } else if notaryFees == emptyString {
                throw RentabilityCalculatorError.notaryFeesMissing
            } else {
                if worksPrice == emptyString {
                    let doubleEstatePrice = estatePrice.transformInDouble
                    let doubleNotaryFees = notaryFees.transformInDouble
                    totalToFinance = doubleEstatePrice + zero + doubleNotaryFees
                } else {
                    let doubleEstatePrice = estatePrice.transformInDouble
                    let doubleWorksPrice = worksPrice.transformInDouble
                    let doubleNotaryFees = notaryFees.transformInDouble
                    totalToFinance = doubleEstatePrice + doubleWorksPrice + doubleNotaryFees
                }
            }
        }
        return totalToFinance
    }
    
    private func getAnnualTotalCharges() throws -> Double {
        var totalCharges = Double()
        if let maintenanceFees = rentabilityData[RentabilityItem.maintenanceFees.titles],
            let propertyTax = rentabilityData[RentabilityItem.propertyTax.titles],
            let charges = rentabilityData[RentabilityItem.charges.titles] {
            if propertyTax == emptyString {
                throw RentabilityCalculatorError.propertyTaxMissing
            } else if charges == emptyString {
                throw RentabilityCalculatorError.chargesMissing
            } else {
                annualManagementFeesAmount = getAnnualManagementFeesAmount()
                let annualInsuranceCost = getAnnualInsuranceCost()
                if maintenanceFees == emptyString {
                    let doublePropertyTax = propertyTax.transformInDouble
                    let doubleCharges = charges.transformInDouble
                    totalCharges = annualManagementFeesAmount + annualInsuranceCost + doublePropertyTax + zero + doubleCharges
                } else {
                    let doublePropertyTax = propertyTax.transformInDouble
                    let doubleMaintenanceFees = maintenanceFees.transformInDouble
                    let doubleCharges = charges.transformInDouble
                    totalCharges = annualManagementFeesAmount + annualInsuranceCost + doublePropertyTax + doubleMaintenanceFees + doubleCharges
                }
            }
        }
        return totalCharges
    }
    
    //MARK: - Public Methods
    func getGrossYield() throws -> String {
        do {
            annualRent = try getAnnualRent()
            totalToFinance = try getTotalToFinance()
        } catch let error as RentabilityCalculator.RentabilityCalculatorError {
            throw error
        }
        let grossYield = annualRent / totalToFinance * hundred
        let stringGrossYield = grossYield.formatIntoStringWithTwoNumbersAfterPoint
        let doubleGrossYield = stringGrossYield.transformInDouble
        let finalGrossYield = doubleGrossYield.clean
        return finalGrossYield
    }
    
    func getNetYield() throws -> String {
        do {
            annualRent = try getAnnualRent()
            annualTotalCharges = try getAnnualTotalCharges()
            totalToFinance = try  getTotalToFinance()
        } catch let error as RentabilityCalculator.RentabilityCalculatorError {
            throw error
        }
        let netYield = (annualRent - annualTotalCharges) / totalToFinance * hundred
        let stringNetYield = netYield.formatIntoStringWithTwoNumbersAfterPoint
        let doubleNetYield = stringNetYield.transformInDouble
        let finalNetYield = doubleNetYield.clean
        return finalNetYield
    }
    
    func getAnnualCashflow() throws -> String {
        do {
            annualRent = try getAnnualRent()
            annualTotalCharges = try getAnnualTotalCharges()
        } catch let error as RentabilityCalculator.RentabilityCalculatorError {
            throw error
        }
        let annualCreditCost = getAnnualCreditCost()
        let annualCashflow = annualRent - annualTotalCharges - annualCreditCost
        let stringAnnualCashflow = annualCashflow.formatIntoStringWithTwoNumbersAfterPoint
        let cashflow = stringAnnualCashflow.transformInDouble
        let finalAnnualCashflow = cashflow.clean
        return finalAnnualCashflow
    }
    
    func getMensualCashflow() throws -> String {
        do {
            annualRent = try getAnnualRent()
            annualTotalCharges = try getAnnualTotalCharges()
        } catch let error as RentabilityCalculator.RentabilityCalculatorError {
            throw error
        }
        let annualCreditCost = getAnnualCreditCost()
        let annualCashflow = annualRent - annualTotalCharges - annualCreditCost
        let mensualCashflow = annualCashflow / numberOfMonths
        let stringMensualCashflow = mensualCashflow.formatIntoStringWithTwoNumbersAfterPoint
        let doubleMensualCashflow = stringMensualCashflow.transformInDouble
        let finalMensualCashflow = doubleMensualCashflow.clean
        return finalMensualCashflow
    }
    
    func isResultPositive(result: String) -> Bool {
        var boolResult = true
        if let numericResult = Double(result) {
            if numericResult >= zero {
                boolResult = true
            } else {
                boolResult = false
            }
        }
        return boolResult
    }
}
