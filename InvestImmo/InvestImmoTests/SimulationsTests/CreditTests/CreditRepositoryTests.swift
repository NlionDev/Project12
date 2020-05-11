//
//  CreditRepositoryTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 04/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift
import XCTest
@testable import InvestImmo

class CreditRepositoryTests: XCTestCase {
    
    var creditRepository: CreditRepository!
    var project: Project!
    let realm = AppDelegate.realm
    
    override func setUp() {
        super.setUp()
        creditRepository = CreditRepository()
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
    
    //Saving credit values to a new project
    func testGivenCreditDataValues_WhenSaveDatas_ThenDatasAreSavedInRealm() {
        creditRepository.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        creditRepository.results = ["580", "20000", "10000", "50000"]
        
        creditRepository.saveNewCreditSimulation(name: "test", project: project, creditRepo: creditRepository)
        
        let savedCreditSimulation = creditRepository.getCreditSimulationWithProjectName(name: "test")
        XCTAssertEqual(savedCreditSimulation.amountToFinance, "100000")
    }
    
    //Saving credit values to existant project
    func testGivenCreditDataValuesAndExistantProject_WhenSaveDatas_ThenDataAreSavedInRealmWithExistantProjectName() {
        creditRepository.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        creditRepository.results = ["580", "20000", "10000", "50000"]
        project.name = "Studio Montpellier"
        
        creditRepository.addCreditSimulationToExistantProject(project: project, creditRepo: creditRepository)
        
        let savedCreditSimulation = creditRepository.getCreditSimulationWithProjectName(name: "Studio Montpellier")
        XCTAssertNotEqual(savedCreditSimulation.name, nil)
        XCTAssertEqual(savedCreditSimulation.name, project.name)
    }
    
    //Retrieving credit simulation from Realm
    func testGivenSavedCreditSimulation_WhenRetrieveCreditSimulation_ThenCorrectSimulationisRetrieve() {
        creditRepository.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        creditRepository.results = ["580", "20000", "10000", "50000"]
        creditRepository.saveNewCreditSimulation(name: "test", project: project, creditRepo: creditRepository)
        
        let savedCreditSimulation = creditRepository.getCreditSimulationWithProjectName(name: "test")
        
        XCTAssertEqual(savedCreditSimulation.name, "test")
        XCTAssertEqual(savedCreditSimulation.amountToFinance, "100000")
        XCTAssertEqual(savedCreditSimulation.mensuality, "580")
    }
    
    //Retrieving credit data from credit simulation
    func testGivenSavedCreditSimulation_WhenRetrieveCreditDatasToDisplay_ThenCorrectDatasAreDisplayed() {
        creditRepository.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        creditRepository.results = ["580", "20000", "10000", "50000"]
        creditRepository.saveNewCreditSimulation(name: "test", project: project, creditRepo: creditRepository)
        let savedCreditSimulation = creditRepository.getCreditSimulationWithProjectName(name: "test")
        
        let crediData = creditRepository.getSavedCreditSimulationResultsData(creditSimulation: savedCreditSimulation)
        
        XCTAssertEqual(crediData.count, 9)
        XCTAssertEqual(crediData[1], "20 ans")
    }
    
    //Deleting credit simulation 
    func testGivenSavedCreditSimulation_WhenDeletingSimulation_ThenRetrievedSimulationIsEqualToNil() {
        creditRepository.creditData = ["Montant à financer": "100000", "Durée": "20", "Taux": "2", "Taux assurance": "1", "Frais de dossier": "500"]
        creditRepository.results = ["580", "20000", "10000", "50000"]
        creditRepository.saveNewCreditSimulation(name: "test", project: project, creditRepo: creditRepository)
        
        guard let realm = realm else {return}
        let creditToDelete = realm.objects(CreditSimulation.self).filter("name = 'test'")
        creditRepository.deleteCreditSimulation(creditToDelete: creditToDelete)
        
        let savedCreditSimulation = creditRepository.getCreditSimulationWithProjectName(name: "test")
        XCTAssertEqual(savedCreditSimulation.name, nil)
        XCTAssertEqual(savedCreditSimulation.amountToFinance, nil)
    }
}
