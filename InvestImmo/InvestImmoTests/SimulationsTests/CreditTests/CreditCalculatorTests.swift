//
//  SimulationsUnitTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 03/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import XCTest
@testable import InvestImmo

class CreditCalculatorTests: XCTestCase {
    
    var creditCalculator: CreditCalculator!
    
    override func setUp() {
        super.setUp()
        creditCalculator = CreditCalculator()
    }

    override func tearDown() {
        super.tearDown()
    }

    //MARK: - Func getStringMensuality Tests
    
    //Mensuality calcul and correct result test
    func testGivenCreditDataValues_WhenCalculateMensualities_ThenWeGetTheCorrectResult() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        let mensuality = try? creditCalculator.getStringMensuality()
        XCTAssertEqual(mensuality, "589.22")
    }
    
    //Mensuality calcul without insurance and correct result test
    func testGivenCreditDataValues_WhenCalculateMensualitiesWithoutInsurance_ThenWeGetTheCorrectResult() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "", "Frais de dossier": "500"]
        let mensuality = try? creditCalculator.getStringMensuality()
        XCTAssertEqual(mensuality, "505.88")
    }
    
    //Mensuality calcul without rate and return error test
    func testGivenMissingRate_WhenCalculateMensualities_ThenHaveRateMissingError() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "", "Taux assurance": "1", "Frais de dossier": "500"]
        XCTAssertThrowsError(try creditCalculator.getStringMensuality()) { error in
            XCTAssertNotNil(error as? CreditCalculator.CreditCalculatorError)
            XCTAssertEqual(error as! CreditCalculator.CreditCalculatorError, CreditCalculator.CreditCalculatorError.rateMissing)
        }
    }
    
    //Mensuality calcul without amount to finance and return error test
    func testGivenMissingAmountToFinance_WhenCalculateMensualities_ThenHaveAmountToFinanceMissingError() {
        creditCalculator.creditData = ["Montant à financer": "", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        XCTAssertThrowsError(try creditCalculator.getStringMensuality()) { error in
            XCTAssertNotNil(error as? CreditCalculator.CreditCalculatorError)
            XCTAssertEqual(error as! CreditCalculator.CreditCalculatorError, CreditCalculator.CreditCalculatorError.amountToFinanceMissing)
        }
    }
    
//MARK: - Func getStringInterestCost Tests
    
    //Interest cost calcul and correct result test
    func testGivenCreditDataValues_WhenCalculateInterestCost_ThenWeGetTheCorrectResult() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        let interestCost = try? creditCalculator.getStringInterestCost()
        XCTAssertEqual(interestCost, "21412")
    }
    
    //Interest cost calcul without rate and return error test
    func testGivenMissingRate_WhenCalculateInterestCost_ThenHaveRateMissingError() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "", "Taux assurance": "1", "Frais de dossier": "500"]
        XCTAssertThrowsError(try creditCalculator.getStringInterestCost()) { error in
            XCTAssertNotNil(error as? CreditCalculator.CreditCalculatorError)
            XCTAssertEqual(error as! CreditCalculator.CreditCalculatorError, CreditCalculator.CreditCalculatorError.rateMissing)
        }
    }
    
    //MARK: - Func getStringInsuranceCost Tests
    
    //Insurance cost calcul and correct result test
    func testGivenCreditDataValues_WhenCalculateInsuranceCost_ThenWeGetTheCorrectResult() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        let insuranceCost = try? creditCalculator.getStringInsuranceCost()
        XCTAssertEqual(insuranceCost, "20000")
    }
    
    //Insurance cost calcul without amount to finance and return error test
    func testGivenMissingAmountToFinance_WhenCalculateInsuranceCost_ThenHaveAmountToFinanceMissingError() {
        creditCalculator.creditData = ["Montant à financer": "", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        XCTAssertThrowsError(try creditCalculator.getStringInsuranceCost()) { error in
            XCTAssertNotNil(error as? CreditCalculator.CreditCalculatorError)
            XCTAssertEqual(error as! CreditCalculator.CreditCalculatorError, CreditCalculator.CreditCalculatorError.amountToFinanceMissing)
        }
    }
    
    //MARK: - Func getTotalCost Tests
    
    //Total cost calcul and correct result test
    func testGivenCreditDataValues_WhenCalculateTotalCost_ThenWeGetTheCorrectResult() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        let totalCost = try? creditCalculator.getTotalCost()
        XCTAssertEqual(totalCost, "141912")
    }
    
    //Total cost calcul without rate and return error test
    func testGivenMissingRate_WhenCalculateTotalCost_ThenHaveRateMissingError() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "", "Taux assurance": "1", "Frais de dossier": "500"]
        XCTAssertThrowsError(try creditCalculator.getTotalCost()) { error in
            XCTAssertNotNil(error as? CreditCalculator.CreditCalculatorError)
            XCTAssertEqual(error as! CreditCalculator.CreditCalculatorError, CreditCalculator.CreditCalculatorError.rateMissing)
        }
    }
    
    //Total cost calcul without amount to finance and return error test
    func testGivenMissingAmountToFinance_WhenCalculateTotalCost_ThenHaveAmountToFinanceMissingError() {
        creditCalculator.creditData = ["Montant à financer": "", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        XCTAssertThrowsError(try creditCalculator.getTotalCost()) { error in
            XCTAssertNotNil(error as? CreditCalculator.CreditCalculatorError)
            XCTAssertEqual(error as! CreditCalculator.CreditCalculatorError, CreditCalculator.CreditCalculatorError.amountToFinanceMissing)
        }
    }
    
    //Total cost calcul without booking fees and correct result test
    func testGivenCreditDataValues_WhenCalculateTotalCostWithoutBookingFees_ThenWeGetTheCorrectResult() {
        creditCalculator.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": ""]
        let totalCost = try? creditCalculator.getTotalCost()
        XCTAssertEqual(totalCost, "141412")
    }
    
}
