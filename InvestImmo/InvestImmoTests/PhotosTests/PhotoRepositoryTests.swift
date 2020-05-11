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
        guard let realm = realm else {return}
            photo.name = "test"
            photo.identifier = "testIdentifier"
            realm.safeWrite {
                realm.add(photo)
            }
        
        let photoIdentifiers = photoRepository.getPhotosIdentifiersWithProjectName(name: "test")
        
        XCTAssertEqual(photoIdentifiers[0], "testIdentifier")
    }
}
