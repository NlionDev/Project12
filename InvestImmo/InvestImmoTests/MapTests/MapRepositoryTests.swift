//
//  MapRepositoryTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 09/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift
import XCTest
@testable import InvestImmo

class MapRepositoryTests: XCTestCase {
    
    var mapRepository: MapRepository!
    var realm = AppDelegate.realm
    var project: Project!
    
    override func setUp() {
        super.setUp()
        mapRepository = MapRepository()
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
    
    //Save new map data
    func testGivenMapData_WhenISaveIntoRealm_ThenDataAreSaved() {
        let name = "test"
        let adress = "test adress"
        let latitude = "test latitude"
        let longitude = "test longitude"
        
        mapRepository.saveMapAdressWithNewProject(project: project, name: name, adress: adress, latitude: latitude, longitude: longitude)
        
        let map = mapRepository.getMapAdressWithProjectName(name: name)
        XCTAssertEqual(map.adress, "test adress")
        XCTAssertEqual(map.name, "test")
        XCTAssertEqual(map.latitude, "test latitude")
        XCTAssertEqual(map.longitude, "test longitude")
    }
    
    //Save map data in existant project
    func testGivenMapDataAndExistantProject_WhenISaveIntoRealm_ThenDataAreSaved() {
        project.name = "test"
        let adress = "test adress"
        let latitude = "test latitude"
        let longitude = "test longitude"
        
        guard let projectName = project.name else {return}
        mapRepository.saveMapAdressInExistantProject(name: projectName, adress: adress, latitude: latitude, longitude: longitude)
        
        let map = mapRepository.getMapAdressWithProjectName(name: projectName)
        XCTAssertEqual(map.adress, "test adress")
        XCTAssertEqual(map.name, "test")
        XCTAssertEqual(map.latitude, "test latitude")
        XCTAssertEqual(map.longitude, "test longitude")
    }
    
    //Delete map data
    func testGivenMapDataSavedInRealm_WhenIDeleteData_ThenNoMoreDataAreSaved() {
        let name = "test"
        let adress = "test adress"
        let latitude = "test latitude"
        let longitude = "test longitude"
        mapRepository.saveMapAdressWithNewProject(project: project, name: name, adress: adress, latitude: latitude, longitude: longitude)
        
        guard let realm = realm else {return}
        let mapAdressToDelete = realm.objects(MapAdress.self).filter("name = 'test'")
        mapRepository.deleteProjectAdress(adressToDelete: mapAdressToDelete)
        
        let map = mapRepository.getMapAdressWithProjectName(name: "test")
        XCTAssertEqual(map.name, nil)
        XCTAssertEqual(map.adress, nil)
        XCTAssertEqual(map.latitude, nil)
        XCTAssertEqual(map.longitude, nil)
    }

}
