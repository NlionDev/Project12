//
//  ChecklistPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ChecklistExistantProjectPopUp {
    
    func alert(checklist: ChecklistRepository) -> AddChecklistToExistantProjectPopUpVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.checklist.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: ChecklistVC.checklistExistantProject.identifier) as! AddChecklistToExistantProjectPopUpVC
        alertVC.checklistRepository = checklist
        return alertVC
    }
}

class ChecklistNewProjectPopUp {
    
    func alert(checklist: ChecklistRepository) -> AddChecklistToNewProjectPopUpVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.checklist.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: ChecklistVC.checklistNewProject.identifier) as! AddChecklistToNewProjectPopUpVC
        alertVC.checklistRepository = checklist
        return alertVC
    }
}

class ReplaceProjectChecklistPopUp {
    
    func alert(project: Project, checklist: ChecklistRepository) -> ReplaceProjectChecklistViewController {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.checklist.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: ChecklistVC.checklistReplaceProject.identifier) as! ReplaceProjectChecklistViewController
        alertVC.checklistRepository = checklist
        alertVC.selectedProject = project
        return alertVC
    }
}
