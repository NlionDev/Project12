//
//  ChecklistRepositoryTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 09/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift
import XCTest
@testable import InvestImmo

class ChecklistRepositoryTests: XCTestCase {
    
    var checklistRepository: ChecklistRepository!
    var project: Project!
    let realm = AppDelegate.realm
    
    override func setUp() {
        super.setUp()
        checklistRepository = ChecklistRepository()
        project = Project()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        
        checklistRepository.checklistData = [
            ["Date de la visite": "04/05/2020", "Type de bien": "T2", "Superficie": "50"],
            ["Nuisances": "Bruits", "Atouts": "Localisation", "Transports en commun": "Tram", "Stationnement facile": "Oui"],
            ["Année de construction": "2005", "Nombre de lots": "20", "Internet": "Fibre", "Syndicat": "Pro", "Qualité façades": "Bon", "Qualité toitures": "Bon", "Qualité communs": "Bon"],
            ["Diagnostic de performances énergétiques": "A", "Lumineux": "Oui", "Traversant": "Oui", "VMC": "Oui", "Présence d'humidité": "Non", "Hauteur sous plafond": "250", "Planéité des sols": "Bon", "Isolation": "Bon ", "Insonorisation": "Bon", "Orientation": "Sud", "Vue de la chambre": "Rue", "Vue de la pièce de vie": "Rue", "Energie du chauffage": "Gaz", "Type de chauffage": "Individuel", "Electricité au normes": "Oui", "Compteur individuel": "Oui", "WC isolé": "Oui", "Salle de bain moderne": "Oui", "Etat robinetterie": "Bon", "Etat des sols": "Bon", "Etat des murs": "Bon", "Etat des volets": "Bon", "Double vitrage": "Oui", "Reconfiguration possible": "Oui", "Présence de cave": "Oui", "Surface cave": "4", "Parking": "Oui", "Elements différenciants par rapport aux autres biens": "Aucun"]
        ]
    }

    override func tearDown() {
        super.tearDown()
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.deleteAll()
        }
    }
    
    //Saving new checklist general into Realm
    func testGivenChecklistValue_WhenISaveChecklistGeneral_ThenDatasAreSavedInRealm() {
        
        checklistRepository.saveNewChecklistGeneral(name: "test", project: project, checklistRepo: checklistRepository)
        
        let checklist = checklistRepository.getChecklistGeneralWithProjectName(name: "test")
        XCTAssertEqual(checklist.estateType, "T2")
        XCTAssertEqual(checklist.visitDate, "04/05/2020")
        XCTAssertEqual(checklist.surfaceArea, "50")
    }
    
    //Saving checklist general to an existant project into Realm
    func testGivenChecklistValueAndExistantProject_WhenISaveChecklistGeneral_ThenDataAreSavedInRealm() {
        project.name = "Studio Montpellier"
        
        checklistRepository.saveChecklistGeneralToExistantProject(project: project, checklistRepo: checklistRepository)
        
        let checklist = checklistRepository.getChecklistGeneralWithProjectName(name: "Studio Montpellier")
        XCTAssertEqual(checklist.estateType, "T2")
        XCTAssertEqual(checklist.visitDate, "04/05/2020")
        XCTAssertEqual(checklist.surfaceArea, "50")
    }
    
    //Saving checklist district into Realm
    func testGivenChecklistValue_WhenISaveChecklistDistrict_ThenDatasAreSavedInRealm() {
        
        checklistRepository.saveChecklistDistrict(name: "test", checklistRepo: checklistRepository)
        
        let checklist = checklistRepository.getChecklistDistrictWithProjectName(name: "test")
        XCTAssertEqual(checklist.advantage, "Localisation")
        XCTAssertEqual(checklist.problem, "Bruits")
        XCTAssertEqual(checklist.transports, "Tram")
        XCTAssertEqual(checklist.easyPark, "Oui")
    }
    
    //Saving checklist apartment block into realm
    func testGivenChecklistValue_WhenISaveChecklistApartmentBlock_ThenDatasAreSavedInRealm() {
        
        checklistRepository.saveChecklistApartmentBlock(name: "test", checklistRepo: checklistRepository)
        
        let checklist = checklistRepository.getChecklistApartmentBlocklWithProjectName(name: "test")
        XCTAssertEqual(checklist.internet, "Fibre")
        XCTAssertEqual(checklist.syndicate, "Pro")
        XCTAssertEqual(checklist.numberOfLots, "20")
        XCTAssertEqual(checklist.roof, "Bon")
    }
    
    //Saving checklist apartment into realm
    func testGivenChecklistValue_WhenISaveChecklistApartment_ThenDatasAreSavedInRealm() {
        
        checklistRepository.saveChecklistApartment(name: "test", checklistRepo: checklistRepository)
        
        let checklist = checklistRepository.getChecklistApartmentWithProjectName(name: "test")
        XCTAssertEqual(checklist.caveSurface, "4")
        XCTAssertEqual(checklist.distinguishElements, "Aucun")
        XCTAssertEqual(checklist.bedroomView, "Rue")
        XCTAssertEqual(checklist.electricityMeters, "Oui")
    }
    
    //Retrieve correct checklist data to display
    func testGivenSavedChecklistData_WhenIRetrieveDatasToDisplay_ThenIGetCorrectDatas() {
        checklistRepository.saveNewChecklistGeneral(name: "test", project: project, checklistRepo: checklistRepository)
        checklistRepository.saveChecklistDistrict(name: "test", checklistRepo: checklistRepository)
        checklistRepository.saveChecklistApartmentBlock(name: "test", checklistRepo: checklistRepository)
        checklistRepository.saveChecklistApartment(name: "test", checklistRepo: checklistRepository)
        let checklistGeneral = checklistRepository.getChecklistGeneralWithProjectName(name: "test")
        let checklistDistrict = checklistRepository.getChecklistDistrictWithProjectName(name: "test")
        let checklistApartmentBlock = checklistRepository.getChecklistApartmentBlocklWithProjectName(name: "test")
        let checklistApartment = checklistRepository.getChecklistApartmentWithProjectName(name: "test")
        
        let checklistData = checklistRepository.getSavedChecklistData(general: checklistGeneral, district: checklistDistrict, block: checklistApartmentBlock, apartment: checklistApartment)
        
        XCTAssertEqual(checklistData[0][1], "T2")
        XCTAssertEqual(checklistData[1][2], "Tram")
        XCTAssertEqual(checklistData[2][3], "Pro")
        XCTAssertEqual(checklistData[3][4], "Non")
    }
    
    //Deleting checkist data
    func testGivenSavedChecklistData_WhenIDeleteChecklist_ThenNoMoreDataAreSaved() {
        checklistRepository.saveNewChecklistGeneral(name: "test", project: project, checklistRepo: checklistRepository)
        checklistRepository.saveChecklistDistrict(name: "test", checklistRepo: checklistRepository)
        checklistRepository.saveChecklistApartmentBlock(name: "test", checklistRepo: checklistRepository)
        checklistRepository.saveChecklistApartment(name: "test", checklistRepo: checklistRepository)
        guard let realm = realm else {return}
        let checklistGeneralToDelete = realm.objects(ChecklistGeneral.self).filter("name = 'test'")
        let checklistDistrictToDelete = realm.objects(ChecklistDistrict.self).filter("name = 'test'")
        let checklistApartmentBlockToDelete = realm.objects(ChecklistApartmentBlock.self).filter("name = 'test'")
        let checklistApartmentToDelete = realm.objects(ChecklistApartment.self).filter("name = 'test'")
        
        checklistRepository.deleteChecklist(checklistGeneralToDelete: checklistGeneralToDelete, checklistDistrictToDelete: checklistDistrictToDelete, checklistApartmentBlockToDelete: checklistApartmentBlockToDelete, checklistApartmentToDelete: checklistApartmentToDelete)
        
        let checklistGeneral = checklistRepository.getChecklistGeneralWithProjectName(name: "test")
        let checklistDistrict = checklistRepository.getChecklistDistrictWithProjectName(name: "test")
        let checklistApartmentBlock = checklistRepository.getChecklistApartmentBlocklWithProjectName(name: "test")
        let checklistApartment = checklistRepository.getChecklistApartmentWithProjectName(name: "test")
        XCTAssertEqual(checklistGeneral.name, nil)
        XCTAssertEqual(checklistDistrict.name, nil)
        XCTAssertEqual(checklistApartmentBlock.name, nil)
        XCTAssertEqual(checklistApartment.name, nil)
    }
}
