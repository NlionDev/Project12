//
//  RentabilityCalculatorTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 04/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import XCTest
@testable import InvestImmo

class RentabilityCalculatorTests: XCTestCase {
    
    var rentabilityCalculator: RentabilityCalculator!
    
    override func setUp() {
        super.setUp()
        rentabilityCalculator = RentabilityCalculator()
    }
    
    override func tearDown() {
        super.tearDown()
        rentabilityCalculator.rentabilityData = ["Prix du bien": "", "Coût des travaux": "", "Frais de notaire": "", "Loyer mensuel": "", "Taxe foncière": "", "Frais d'entretien": "", "Charges de copropriété": "", "Frais de gérance": "", "Assurance loyers impayés": "", "Coût du crédit": ""]
    }
    
    //MARK: - func getGrossYield Tests
    
    //Gross Yiedl calcul and correct result test
    func testGivenRentabilityValues_WhenGetGrossYield_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        let grossYield = try? rentabilityCalculator.getGrossYield()
        
        XCTAssertEqual(grossYield, "7.68")
    }
    
    //Gross Yield calcul without works price and correct result test
    func testGivenRentabilityValuesWithoutWorksPrice_WhenGetGrossYield_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        let grossYield = try? rentabilityCalculator.getGrossYield()
        
        XCTAssertEqual(grossYield, "9.14")
    }
    
    //Gross Yield calcul without monthly rent and return error test
    func testGivenRentabilityValuesWithoutMonthlyRent_WhenGetGrossYield_ThenMonthlyRentMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getGrossYield()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.monthlyRentMissing)
        }
    }
    
    //Gross Yield calcul without estate price and return error test
    func testGivenRentabilityValuesWithoutEstatePrice_WhenGetGrossYield_ThenEstatePriceMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getGrossYield()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.estatePriceMissing)
        }
    }
    
    //Gross Yield calcul withtout notary fees and return error test
    func testGivenRentabilityValuesWithoutNotaryFees_WhenGetGrossYield_ThenNotaryFeesMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getGrossYield()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.notaryFeesMissing)
        }
    }
    
    //MARK: - Func getNetYield Tests
    
    //Net Yield calcul and correct result test
    func testGivenRentabilityValues_WhenGetNetYield_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        let netYield = try? rentabilityCalculator.getNetYield()
        
        XCTAssertEqual(netYield, "6.8")
    }
    
    //Net Yield calcul without management fees and correct result test
    func testGivenRentabilityValuesWithoutManagementFees_WhenGetNetYield_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        let netYield = try? rentabilityCalculator.getNetYield()
        
        XCTAssertEqual(netYield, "6.8")
    }
    
    //Net Yield calcul without maintenance fees and correct result test
    func testGivenRentabilityValuesWithoutMaintenanceFees_WhenGetNetYield_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        let netYield = try? rentabilityCalculator.getNetYield()
        
        XCTAssertEqual(netYield, "6.88")
    }
    
    //Net Yield calcul without insurance cost and correct result test
    func testGivenRentabilityValuesWithoutInsuranceCost_WhenGetNetYield_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "", "Coût du crédit": "500"]
        
        let netYield = try? rentabilityCalculator.getNetYield()
        
        XCTAssertEqual(netYield, "6.8")
    }
    
    //Net Yield calcul without property tax and return error test
    func testGivenRentabilityValuesWithoutPropertyTax_WhenGetNetYield_ThenPropertyTaxMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getNetYield()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.propertyTaxMissing)
        }
    }
    
    //Net Yield calcul without charges and return error test
    func testGivenRentabilityValuesWithoutCharges_WhenGetNetYield_ThenChargesMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getNetYield()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.chargesMissing)
        }
    }
    
    //MARK: - Func getAnnualCashflow Tests
    
    //Annual cashflow calcul and correct result test
    func testGivenRentabilityValues_WhenGetAnnualCashflow_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        let annualCahsflow = try? rentabilityCalculator.getAnnualCashflow()
        
        XCTAssertEqual(annualCahsflow, "2500")
    }
    
    
    func testGivenRentabilityValuesWithoutMonthlyRent_WhenGetAnnualCashflow_ThenMonthlyRentMissingErrorAppears() {
         rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
         
         XCTAssertThrowsError(try rentabilityCalculator.getAnnualCashflow()) { error in
             XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
             XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.monthlyRentMissing)
         }
     }
    
    func testGivenRentabilityValuesWithoutPropertyTax_WhenGetAnnualCashflow_ThenPropertyTaxMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getAnnualCashflow()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.propertyTaxMissing)
        }
    }
    
    func testGivenRentabilityValuesWithoutCharges_WhenGetAnnualCashflow_ThenChargesMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getAnnualCashflow()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.chargesMissing)
        }
    }
    
    func testGivenRentabilityValuesWithoutCreditCost_WhenAnnualCashflow_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": ""]
        
        let annualCashflow = try? rentabilityCalculator.getAnnualCashflow()
        
        XCTAssertEqual(annualCashflow, "8500")
    }
    
    //MARK: - Func getMensualCashflow Tests
    func testGivenRentabilityValues_WhenGetMensualCashflow_ThenWeGetCorrectResult() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        let mensualCahsflow = try? rentabilityCalculator.getMensualCashflow()
        
        XCTAssertEqual(mensualCahsflow, "208.33")
    }
    
    func testGivenRentabilityValuesWithoutMonthlyRent_WhenGetMensualCashflow_ThenMonthlyRentMissingErrorAppears() {
         rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
         
         XCTAssertThrowsError(try rentabilityCalculator.getMensualCashflow()) { error in
             XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
             XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.monthlyRentMissing)
         }
     }
    
    func testGivenRentabilityValuesWithoutPropertyTax_WhenGetMensualCashflow_ThenPropertyTaxMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getMensualCashflow()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.propertyTaxMissing)
        }
    }
    
    func testGivenRentabilityValuesWithoutCharges_WhenGetMensualCashflow_ThenChargesMissingErrorAppears() {
        rentabilityCalculator.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "", "Frais de gérance": "0", "Assurance loyers impayés": "0", "Coût du crédit": "500"]
        
        XCTAssertThrowsError(try rentabilityCalculator.getMensualCashflow()) { error in
            XCTAssertNotNil(error as? RentabilityCalculator.RentabilityCalculatorError)
            XCTAssertEqual(error as! RentabilityCalculator.RentabilityCalculatorError, RentabilityCalculator.RentabilityCalculatorError.chargesMissing)
        }
    }
    
    //MARK: - Func isResultPositive Tests
    func testGivenPositiveResult_WhenCallIsResultPositiveFunc_ThenTrueValueIsReturned() {
        let positiveResult = "200"
        
        let boolResult = rentabilityCalculator.isResultPositive(result: positiveResult)
        
        XCTAssertEqual(boolResult, true)
    }
    
    func testGivenNegativeResult_WhenCallIsResultPositiveFunc_ThenFalseValueIsReturned() {
        let negativeResult = "-200"
        
        let boolResult = rentabilityCalculator.isResultPositive(result: negativeResult)
        
        XCTAssertEqual(boolResult, false)
    }
}
