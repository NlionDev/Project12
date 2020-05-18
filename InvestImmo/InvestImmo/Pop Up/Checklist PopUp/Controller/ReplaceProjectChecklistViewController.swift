//
//  ReplaceProjectChecklistViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ReplaceProjectChecklistViewController: UIViewController {

    //MARK: - Properties
    var selectedProject: Project?
    var checklistRepository: ChecklistRepository?
    
    //MARK: - Actions
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
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
