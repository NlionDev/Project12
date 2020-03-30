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
    
    var estatePrice = ""
    var worksPrice = ""
    var notaryFees = ""
    var monthlyRent = ""
    var propertyTax = ""
    var maintenanceFees = ""
    var charges = ""
    var managementFees = ""
    var insurance = ""
    var creditCost = ""
    
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
        var annualRent = 0.00
        if let doubleMonthlyRent = Double(monthlyRent.replacingOccurrences(of: ",", with: ".")) {
            annualRent = doubleMonthlyRent * 12
        }
        return annualRent
    }
    
    private func getAnnualManagementFeesAmount() -> Double {
        var annualManagementFeesAmount = 0.00
        if managementFees == "" {
            annualManagementFeesAmount = 0.00
        } else {
            if let doubleMonthlyRent = Double(monthlyRent.replacingOccurrences(of: ",", with: ".")),
                let doubleManagementFees = Double(managementFees.replacingOccurrences(of: ",", with: ".")) {
                let managementFeesAmount = doubleMonthlyRent * doubleManagementFees / 100
                annualManagementFeesAmount = managementFeesAmount * 12
            }
        }
        return annualManagementFeesAmount
    }
    
    private func getAnnualInsuranceCost() -> Double {
        var annualInsuranceCost = 0.00
        if insurance == "" {
            annualInsuranceCost = 0.00
        } else {
            if let doubleInsurance = Double(insurance.replacingOccurrences(of: ",", with: ".")) {
                annualInsuranceCost = doubleInsurance * 12
            }
        }
        return annualInsuranceCost
    }
    
    private func getAnnualCreditCost() -> Double {
        var annualCreditCost = 0.00
        if creditCost == "" {
            annualCreditCost = 0.00
        } else {
            if let doubleCreditCost = Double(creditCost.replacingOccurrences(of: ",", with: ".")) {
                annualCreditCost = doubleCreditCost * 12
            }
        }
        return annualCreditCost
    }
    
    private func getTotalToFinance() -> Double {
        var totalToFinance = 0.00
        if worksPrice == "" {
            if let doubleEstatePrice = Double(estatePrice.replacingOccurrences(of: ",", with: ".")),
                let doubleNotaryFees = Double(notaryFees.replacingOccurrences(of: ",", with: ".")) {
                totalToFinance = doubleEstatePrice + 0.00 + doubleNotaryFees
            }
        } else {
            if let doubleEstatePrice = Double(estatePrice.replacingOccurrences(of: ",", with: ".")),
                let doubleWorksPrice = Double(worksPrice.replacingOccurrences(of: ",", with: ".")),
                let doubleNotaryFees = Double(notaryFees.replacingOccurrences(of: ",", with: ".")) {
                totalToFinance = doubleEstatePrice + doubleWorksPrice + doubleNotaryFees
            }
        }
        return totalToFinance
    }
    
    private func getAnnualTotalCharges() -> Double {
        var totalCharges = 0.00
        let annualManagementFeesAmount = getAnnualManagementFeesAmount()
        let annualInsuranceCost = getAnnualInsuranceCost()
        if maintenanceFees == "" {
            if let doublePropertyTax = Double(propertyTax.replacingOccurrences(of: ",", with: ".")),
                let doubleCharges = Double(charges.replacingOccurrences(of: ",", with: ".")) {
                totalCharges = annualManagementFeesAmount + annualInsuranceCost + doublePropertyTax + 0.00 + doubleCharges
            }
        } else {
            if let doublePropertyTax = Double(propertyTax.replacingOccurrences(of: ",", with: ".")),
                let doubleMaintenanceFees = Double(maintenanceFees.replacingOccurrences(of: ",", with: ".")),
                let doubleCharges = Double(charges.replacingOccurrences(of: ",", with: ".")) {
                totalCharges = annualManagementFeesAmount + annualInsuranceCost + doublePropertyTax + doubleMaintenanceFees + doubleCharges
            }
        }
        return totalCharges
    }
    
    func getGrossYield() -> String {
        var grossYield = 0.00
        var finalGrossYield = ""
        let annualRent = getAnnualRent()
        let totalToFinance = getTotalToFinance()
        
        grossYield = annualRent / totalToFinance * 100
        let stringGrossYield = String(format: "%.02f", grossYield)
        if let doubleGrossYield = Double(stringGrossYield) {
            finalGrossYield = doubleGrossYield.clean
        }
        return finalGrossYield
    }
    
    func getNetYield() -> String {
        var netYield = 0.00
        var finalNetYield = ""
        let annualRent = getAnnualRent()
        let annualTotalCharges = getAnnualTotalCharges()
        let totalToFinance = getTotalToFinance()
        netYield = (annualRent - annualTotalCharges) / totalToFinance * 100
        let stringNetYield = String(format: "%.02f", netYield)
        if let doubleNetYield = Double(stringNetYield) {
            finalNetYield = doubleNetYield.clean
        }
        return finalNetYield
    }
    
    func getAnnualCashflow() -> String {
        var annualCashflow = 0.00
        var finalAnnualCashflow = ""
        let annualRent = getAnnualRent()
        let annualTotalCharges = getAnnualTotalCharges()
        let annualCreditCost = getAnnualCreditCost()
        annualCashflow = annualRent - annualTotalCharges - annualCreditCost
        let stringAnnualCashflow = String(format: "%.02f", annualCashflow)
        if let cashflow = Double(stringAnnualCashflow) {
            finalAnnualCashflow = cashflow.clean
        }
        return finalAnnualCashflow
    }
    
    func getMensualCashflow() -> String {
        var mensualCashflow = 0.00
        var finalMensualCashflow = ""
        let annualRent = getAnnualRent()
        let annualTotalCharges = getAnnualTotalCharges()
        let annualCreditCost = getAnnualCreditCost()
        let annualCashflow = annualRent - annualTotalCharges - annualCreditCost
        mensualCashflow = annualCashflow / 12
        let stringMensualCashflow = String(format: "%.02f", mensualCashflow)
        if let doubleMensualCashflow = Double(stringMensualCashflow) {
            finalMensualCashflow = doubleMensualCashflow.clean
        }
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
