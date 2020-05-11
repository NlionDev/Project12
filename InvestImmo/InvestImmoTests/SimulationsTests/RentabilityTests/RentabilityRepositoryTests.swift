//
//  RentabilityRepositoryTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 09/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift
import XCTest
@testable import InvestImmo

class RentabilityRepositoryTests: XCTestCase {
    
    
    var rentabilityRepository: RentabilityRepository!
    var project: Project!
    let realm = AppDelegate.realm
    
    override func setUp() {
        super.setUp()
        rentabilityRepository = RentabilityRepository()
        project = Project()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        super.tearDown()
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.deleteAll()
        }
    }
    
     //Saving rentability values to a new project
       func testGivenCreditDataValues_WhenSaveDatas_ThenDatasAreSavedInRealm() {
           rentabilityRepository.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "5", "Coût du crédit": "400"]
           rentabilityRepository.results = ["7.68", "6.75", "3640", "303.33"]
           
        rentabilityRepository.saveNewRentabilitySimulation(name: "test", project: project, rentaRepo: rentabilityRepository)
           
        let savedRentabilitySimulation = rentabilityRepository.getRentabilitySimulationWithProjectName(name: "test")
        XCTAssertEqual(savedRentabilitySimulation.estatePrice, "100000")
        XCTAssertEqual(savedRentabilitySimulation.annualCashflow, "3640")
       }
       
       //Saving rentability values to existant project
       func testGivenCreditDataValuesAndExistantProject_WhenSaveDatas_ThenDataAreSavedInRealmWithExistantProjectName() {
           rentabilityRepository.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "5", "Coût du crédit": "400"]
           rentabilityRepository.results = ["7.68", "6.75", "3640", "303.33"]
           project.name = "Studio Montpellier"
           
        rentabilityRepository.addRentabilitySimulationToExistantProject(project: project, rentaRepo: rentabilityRepository)
           
        let savedRentabilitySimulation = rentabilityRepository.getRentabilitySimulationWithProjectName(name: "Studio Montpellier")
           XCTAssertNotEqual(savedRentabilitySimulation.name, nil)
           XCTAssertEqual(savedRentabilitySimulation.name, project.name)
       }
       
       //Retrieving rentability simulation from Realm
       func testGivenSavedCreditSimulation_WhenRetrieveCreditSimulation_ThenCorrectSimulationisRetrieve() {
           rentabilityRepository.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "5", "Coût du crédit": "400"]
           rentabilityRepository.results = ["7.68", "6.75", "3640", "303.33"]
        rentabilityRepository.saveNewRentabilitySimulation(name: "test", project: project, rentaRepo: rentabilityRepository)
           
        let savedRentabilitySimulation = rentabilityRepository.getRentabilitySimulationWithProjectName(name: "test")
           
           XCTAssertEqual(savedRentabilitySimulation.name, "test")
           XCTAssertEqual(savedRentabilitySimulation.estatePrice, "100000")
           XCTAssertEqual(savedRentabilitySimulation.annualCashflow, "3640")
       }
       
       //Retrieving rentability data from rentability simulation
       func testGivenSavedCreditSimulation_WhenRetrieveCreditDatasToDisplay_ThenCorrectDatasAreDisplayed() {
           rentabilityRepository.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "5", "Coût du crédit": "400"]
           rentabilityRepository.results = ["7.68", "6.75", "3640", "303.33"]
           rentabilityRepository.saveNewRentabilitySimulation(name: "test", project: project, rentaRepo: rentabilityRepository)
        let savedRentabilitySimulation = rentabilityRepository.getRentabilitySimulationWithProjectName(name: "test")
           
        let crediData = rentabilityRepository.getSavedRentabilitySimulationResultsData(simulation: savedRentabilitySimulation)
           
           XCTAssertEqual(crediData.count, 14)
           XCTAssertEqual(crediData[3], "800 €")
       }
       
       //Deleting rentability simulation
       func testGivenSavedCreditSimulation_WhenDeletingSimulation_ThenRetrievedSimulationIsEqualToNil() {
           rentabilityRepository.rentabilityData = ["Prix du bien": "100000", "Coût des travaux": "20000", "Frais de notaire": "5000", "Loyer mensuel": "800", "Taxe foncière": "500", "Frais d'entretien": "100", "Charges de copropriété": "500", "Frais de gérance": "0", "Assurance loyers impayés": "5", "Coût du crédit": "400"]
           rentabilityRepository.results = ["7.68", "6.75", "3640", "303.33"]
        rentabilityRepository.saveNewRentabilitySimulation(name: "test", project: project, rentaRepo: rentabilityRepository)
           
           guard let realm = realm else {return}
           let rentabilityToDelete = realm.objects(RentabilitySimulation.self).filter("name = 'test'")
        rentabilityRepository.deleteRentabilitySimulation(rentabilityToDelete: rentabilityToDelete)
           
        let savedRentabilitySimulation = rentabilityRepository.getRentabilitySimulationWithProjectName(name: "test")
           XCTAssertEqual(savedRentabilitySimulation.name, nil)
           XCTAssertEqual(savedRentabilitySimulation.estatePrice, nil)
       }
}
