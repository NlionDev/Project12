//
//  AddNewProjectAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 05/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

/// Class for AddChecklistToNewProjectPopUpVC
class AddChecklistToNewProjectPopUpVC: UIViewController {

    //MARK: - Properties
    
    /// Instance of ErrorAlert for present alert
    private let errorAlert = ErrorAlert()
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Instance of Project
    private var project = Project()
    
    /// Instance of ChecklistGeneral
    private var checklistGeneral = ChecklistGeneral()
    
    /// Instance of ChecklistDistrict
    private var checklistDistrict = ChecklistDistrict()
    
    /// Instance of ChecklistApartmentBlock
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    
    /// Instance of ChecklistApartment
    private var checklistApartment = ChecklistApartment()
    
    /// Property to store ChecklistRepository past from viewcontroller who present the pop up
    var checklistRepository: ChecklistRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var projectNameLabel: UITextField!
    
    //MARK: - Actions
    
    /// Action activated when tap on new project button for save the checklist  in a new project
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectNameLabel.text,
            let checklistRepo = checklistRepository else {return}
        if projectRepository.isMyProjectNameUnique(name: name) {
            checklistRepo.saveNewChecklistGeneral(name: name, project: project, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistDistrict(name: name, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartmentBlock(name: name, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartment(name: name, checklistRepo: checklistRepo)
            dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.dismissFromPrevious.name), object: nil)
        } else {
            let alert = errorAlert.alert(message: PopUpAlertMessage.projectAlreadyExist.message)
            present(alert, animated: true)
        }
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /// Action activated when tap on screen so that textfields resign first responder
    @IBAction func dismissKeyboard(_ sender: Any) {
        projectNameLabel.resignFirstResponder()
    }
    
}

//MARK: - Extension

/// Extension of AddChecklistToNewProjectPopUpVC for textfield delegate method
extension AddChecklistToNewProjectPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameLabel.resignFirstResponder()
    }
}
