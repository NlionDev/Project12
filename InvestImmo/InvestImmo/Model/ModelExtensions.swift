//
//  ModelExtensions.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 05/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UIViewController {
    
    func isMyProjectNameUnique(name: String, projects: Results<Project>) -> Bool {
        var result = true
        for project in projects {
            if name == project.name {
                result = false
            } else {
                result = true
            }
        }
        return result
    }
    
    func isMySavedProjectsNil(projects: Results<Project>) -> Bool {
        if projects.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func isMySimulationDataNil(simulationCashflow: String!) -> Bool {
        if simulationCashflow == nil {
            return true
        } else {
            return false
        }
    }
}
