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
    
    //MARK: - Enum
    
    enum RentabilityCalculatorError: Error {
        case estatePriceMissing
        case notaryFeesMissing
        case monthlyRentMissing
        case propertyTaxMissing
        case chargesMissing
    }
    
    //MARK: - Methods
    
    private func getAnnualRent() -> Double {
        var annualRent = Double()
        if let monthlyRent = rentabilityData["Loyer mensuel"] {
        let doubleMonthlyRent = monthlyRent.transformInDouble
        annualRent = doubleMonthlyRent * 12
        }
        return annualRent
    }
    
    private func getAnnualManagementFeesAmount() -> Double {
        var annualManagementFeesAmount = Double()
        if let managementFees = rentabilityData["Frais de gérance"],
            let monthlyRent = rentabilityData["Loyer Mensuel"] {
            if managementFees == "" {
                annualManagementFeesAmount = 0.00
            } else {
                let doubleMonthlyRent = monthlyRent.transformInDouble
                let doubleManagementFees = managementFees.transformInDouble
                let managementFeesAmount = doubleMonthlyRent * doubleManagementFees / 100
                annualManagementFeesAmount = managementFeesAmount * 12
            }
        }
        return annualManagementFeesAmount
    }
    
    private func getAnnualInsuranceCost() -> Double {
        var annualInsuranceCost = Double()
        if let insurance = rentabilityData["Assurance loyers impayés"] {
            if insurance == "" {
                annualInsuranceCost = 0.00
            } else {
                let doubleInsurance = insurance.transformInDouble
                annualInsuranceCost = doubleInsurance * 12
            }
        }
        return annualInsuranceCost
    }
    
    private func getAnnualCreditCost() -> Double {
        var annualCreditCost = Double()
        if let creditCost = rentabilityData["Coût du crédit"] {
            if creditCost == "" {
                annualCreditCost = 0.00
            } else {
                let doubleCreditCost = creditCost.transformInDouble
                annualCreditCost = doubleCreditCost * 12
            }
        }
        return annualCreditCost
    }
    
    private func getTotalToFinance() -> Double {
        var totalToFinance = Double()
        if let worksPrice = rentabilityData["Coût des travaux"],
            let estatePrice = rentabilityData["Prix du bien"],
            let notaryFees = rentabilityData["Frais de notaire"] {
            if worksPrice == "" {
                let doubleEstatePrice = estatePrice.transformInDouble
                let doubleNotaryFees = notaryFees.transformInDouble
                totalToFinance = doubleEstatePrice + 0.00 + doubleNotaryFees
            } else {
                let doubleEstatePrice = estatePrice.transformInDouble
                let doubleWorksPrice = worksPrice.transformInDouble
                let doubleNotaryFees = notaryFees.transformInDouble
                totalToFinance = doubleEstatePrice + doubleWorksPrice + doubleNotaryFees
            }
        }
        return totalToFinance
    }
    
    private func getAnnualTotalCharges() -> Double {
        var totalCharges = Double()
        if let maintenanceFees = rentabilityData["Frais d'entretien"],
            let propertyTax = rentabilityData["Taxe foncière"],
            let charges = rentabilityData["Charges de copropriété"] {
            let annualManagementFeesAmount = getAnnualManagementFeesAmount()
            let annualInsuranceCost = getAnnualInsuranceCost()
            if maintenanceFees == "" {
                let doublePropertyTax = propertyTax.transformInDouble
                let doubleCharges = charges.transformInDouble
                totalCharges = annualManagementFeesAmount + annualInsuranceCost + doublePropertyTax + 0.00 + doubleCharges
            } else {
                let doublePropertyTax = propertyTax.transformInDouble
                let doubleMaintenanceFees = maintenanceFees.transformInDouble
                let doubleCharges = charges.transformInDouble
                totalCharges = annualManagementFeesAmount + annualInsuranceCost + doublePropertyTax + doubleMaintenanceFees + doubleCharges
            }
        }
        return totalCharges
    }
    
    func getGrossYield() -> String {
        let annualRent = getAnnualRent()
        let totalToFinance = getTotalToFinance()
        let grossYield = annualRent / totalToFinance * 100
        let stringGrossYield = grossYield.formatIntoStringWithTwoNumbersAfterPoint
        let doubleGrossYield = stringGrossYield.transformInDouble
        let finalGrossYield = doubleGrossYield.clean
        return finalGrossYield
    }
    
    func getNetYield() -> String {
        let annualRent = getAnnualRent()
        let annualTotalCharges = getAnnualTotalCharges()
        let totalToFinance = getTotalToFinance()
        let netYield = (annualRent - annualTotalCharges) / totalToFinance * 100
        let stringNetYield = netYield.formatIntoStringWithTwoNumbersAfterPoint
        let doubleNetYield = stringNetYield.transformInDouble
        let finalNetYield = doubleNetYield.clean
        return finalNetYield
    }
    
    func getAnnualCashflow() -> String {
        let annualRent = getAnnualRent()
        let annualTotalCharges = getAnnualTotalCharges()
        let annualCreditCost = getAnnualCreditCost()
        let annualCashflow = annualRent - annualTotalCharges - annualCreditCost
        let stringAnnualCashflow = annualCashflow.formatIntoStringWithTwoNumbersAfterPoint
        let cashflow = stringAnnualCashflow.transformInDouble
        let finalAnnualCashflow = cashflow.clean
        return finalAnnualCashflow
    }
    
    func getMensualCashflow() -> String {
        let annualRent = getAnnualRent()
        let annualTotalCharges = getAnnualTotalCharges()
        let annualCreditCost = getAnnualCreditCost()
        let annualCashflow = annualRent - annualTotalCharges - annualCreditCost
        let mensualCashflow = annualCashflow / 12
        let stringMensualCashflow = mensualCashflow.formatIntoStringWithTwoNumbersAfterPoint
        let doubleMensualCashflow = stringMensualCashflow.transformInDouble
        let finalMensualCashflow = doubleMensualCashflow.clean
        return finalMensualCashflow
    }
    
    
    func isResultPositive(result: String) -> Bool {
        var boolResult = true
        if let numericResult = Double(result) {
            if numericResult >= 0.00 {
                boolResult = true
            } else {
                boolResult = false
            }
        }
        return boolResult
    }
}
