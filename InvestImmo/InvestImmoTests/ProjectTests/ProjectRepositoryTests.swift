//
//  ProjectRepositoryTests.swift
//  InvestImmoTests
//
//  Created by Nicolas Lion on 09/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift
import XCTest
@testable import InvestImmo

class ProjectRepositoryTests: XCTestCase {
    
    var projectRepository: ProjectRepository!
    var realm = AppDelegate.realm
    
    override func setUp() {
        super.setUp()
        projectRepository = ProjectRepository()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        super.tearDown()
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.deleteAll()
        }
    }
    
    //Saving new empty project
    func testGivenNoProjectSaved_WhenISaveNewEmptyProject_ThenNewProjectIsSaveIntoRealm() {
        
        projectRepository.saveEmptyNewProject(name: "New Project")
        
        guard let realm = realm else {return}
        let project = realm.objects(Project.self).filter("name = 'New Project'")
        
        XCTAssertEqual(project.count, 1)
        XCTAssertEqual(projectRepository.myProjects[0].name, "New Project")
    }
}
