//
//  ReplaceProjectChecklistViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for ReplaceProjectChecklistViewController
class ReplaceProjectChecklistViewController: UIViewController {

    //MARK: - Properties
    
    /// Property to store Project past from viewcontroller who present the pop up
    var selectedProject: Project?
    
    /// Property to store ChecklistRepository past from viewcontroller who present the pop up
    var checklistRepository: ChecklistRepository?
    
    //MARK: - Actions
    
    /// Action activated when tap on yes button for delete previous checklist and save new checklist to the selected project
    @IBAction func didTapOnYesButton(_ sender: Any) {
        guard let checklistRepository = checklistRepository,
            let realm = checklistRepository.realm,
            let project = selectedProject,
            let projectName = project.name else {return}
        let checklistGeneralToDelete = realm.objects(ChecklistGeneral.self).filter("name = '\(projectName)'")
        let checklistDistrictToDelete = realm.objects(ChecklistDistrict.self).filter("name = '\(projectName)'")
        let checklistApartmentBlockToDelete = realm.objects(ChecklistApartmentBlock.self).filter("name = '\(projectName)'")
        let checklistApartmentToDelete = realm.objects(ChecklistApartment.self).filter("name = '\(projectName)'")
        checklistRepository.deleteChecklist(checklistGeneralToDelete: checklistGeneralToDelete, checklistDistrictToDelete: checklistDistrictToDelete, checklistApartmentBlockToDelete: checklistApartmentBlockToDelete, checklistApartmentToDelete: checklistApartmentToDelete)
        checklistRepository.saveChecklistGeneralToExistantProject(project: project, checklistRepo: checklistRepository)
        checklistRepository.saveChecklistDistrict(name: projectName, checklistRepo: checklistRepository)
        checklistRepository.saveChecklistApartmentBlock(name: projectName, checklistRepo: checklistRepository)
        checklistRepository.saveChecklistApartment(name: projectName, checklistRepo: checklistRepository)
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
