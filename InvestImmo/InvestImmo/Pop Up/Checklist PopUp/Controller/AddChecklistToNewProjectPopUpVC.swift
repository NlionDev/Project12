//
//  AddNewProjectAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 05/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class AddChecklistToNewProjectPopUpVC: UIViewController {

    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let projectRepository = ProjectRepository()
    private var project = Project()
    private var checklistGeneral = ChecklistGeneral()
    private var checklistDistrict = ChecklistDistrict()
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    private var checklistApartment = ChecklistApartment()
    var checklistRepository: ChecklistRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var projectNameLabel: UITextField!
    
    //MARK: - Actions
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectNameLabel.text,
            let checklistRepo = checklistRepository else {return}
        if isMyProjectNameUnique(name: name, projects: projectRepository.myProjects) {
            checklistRepo.saveNewChecklistGeneral(name: name, project: project, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistDistrict(name: name, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartmentBlock(name: name, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartment(name: name, checklistRepo: checklistRepo)
            dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissPreviousAlert"), object: nil)
        } else {
            let alert = errorAlert.alert(message: "Un projet existant porte déjà ce nom.")
            present(alert, animated: true)
        }
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        projectNameLabel.resignFirstResponder()
    }
    
}

//MARK: - Extension
extension AddChecklistToNewProjectPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameLabel.resignFirstResponder()
    }
}
