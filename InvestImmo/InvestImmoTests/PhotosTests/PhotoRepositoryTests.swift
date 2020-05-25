//
//  PhotoRepositoryTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 09/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift
import XCTest
@testable import InvestImmo

class PhotoRepositoryTests: XCTestCase {
    
    var photoRepository: PhotoRepository!
    var realm = AppDelegate.realm
    var photo = Photo()
    
    override func setUp() {
        super.setUp()
        photoRepository = PhotoRepository()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        super.tearDown()
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.deleteAll()
        }
    }
    
    
    //Retrieve saved photo identifiers
    func testGivenSavedPhotoIdentifiers_WhenIRetrieveThem_ThenIGetCorrectIdentifiers() {
        photoRepository.savePhoto(name: "test", identifier: "testIdentifier")
        
        let photoIdentifiers = photoRepository.getPhotosIdentifiersWithProjectName(name: "test")
        
        XCTAssertEqual(photoIdentifiers[0], "testIdentifier")
    }
    
    //Deleting Photo
    func testGivenSavedPhoto_WhenIDeleteThisPhoto_ThenNoMorePhotoIsSaved() {
        let identifier = "testIdentifier"
        let name = "test"
        photoRepository.savePhoto(name: name, identifier: identifier)
        
        photoRepository.deletePhotoWithIdentifier(identifier: identifier, name: name)
        guard let realm = realm else {return}
        let photos = realm.objects(Photo.self).filter("name = '\(name)' AND identifier = '\(identifier)'")
        
        XCTAssertEqual(photos.count, 0)
    }
    
    //Check if photo is unique and return false
    func testGivenSavedPhoto_WhenICheckIfNewPhotoIsUnique_ThenReturnFalse() {
        let name = "test"
        let identifier = "testIdentifier"
        photoRepository.savePhoto(name: name, identifier: identifier)
        
        let result = photoRepository.isUniquePhoto(name: name, identifier: identifier)
        
        XCTAssertEqual(result, false)
    }
    
    //Check if photo is unique and return true
    func testGivenSavedPhoto_WhenICheckIfNewPhotoIsUnique_ThenReturnTrue() {
        let name = "test"
        let identifier = "testIdentifier"
        let identifier2 = "testIdentifier2"
        photoRepository.savePhoto(name: name, identifier: identifier)
        
        let result = photoRepository.isUniquePhoto(name: name, identifier: identifier2)
        
        XCTAssertEqual(result, true)
    }
}
