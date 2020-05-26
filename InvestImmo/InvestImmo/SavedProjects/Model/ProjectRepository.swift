//
//  ProjectRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

/// Class for ProjectRepository
class ProjectRepository {
    
    //MARK: - Properties
    
    /// Instance of Realm
    let realm = AppDelegate.realm
    
    /// Instance of Project
    private var project = Project()
    
    /// Property for store saved projects
    lazy var myProjects: Results<Project> = {
        realm?.objects(Project.self)}()!
    
    
    //MARK: - Methods
    
    /// Method for save new project
    func saveEmptyNewProject(name: String) {
        guard let realm = realm else {return}
        project.name = name
        realm.safeWrite {
            realm.add(project)
        }
    }
    
    /// Method for check if a project name is unique 
    func isMyProjectNameUnique(name: String) -> Bool {
        var result = Bool()
        if let realm = realm {
            let sameProject = realm.objects(Project.self).filter("name = '\(name)'")
            if sameProject.count == 0 {
                result = true
            } else {
                result = false
            }
        }
        return result
    }
    
}
