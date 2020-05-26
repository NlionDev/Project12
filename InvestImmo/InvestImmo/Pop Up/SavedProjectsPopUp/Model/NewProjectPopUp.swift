//
//  NewProjectPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for EmptyNewProjectPopUp
class EmptyNewProjectPopUp {
    
    /// Method for instatiate CreateNewProjectViewController and present alert
    func alert() -> CreateNewProjectViewController {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.savedProjects.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: newProjectVCIdentifier) as! CreateNewProjectViewController
        return alertVC
    }
}
