//
//  AddRentabilityToNewProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for AddRentabilityToNewProjectPopUpVC
class AddRentabilityToNewProjectPopUpVC: UIViewController {

    //MARK: - Properties
    
    /// Instance of ErrorAlert for present alert
    private let errorAlert = ErrorAlert()
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Instance of Project
    private let project = Project()
    
    /// Instance of RentabilityRepository past from ViewController who present pop up
    var rentabilityRepository: RentabilityRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var projectNameTextField: UITextField!
    
    //MARK: - Actions
    
    /// Action activated when tap on new project button for save the rentability simulation in a new project
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectNameTextField.text,
            let rentaRepo = rentabilityRepository else {return}
        if projectRepository.isMyProjectNameUnique(name: name) {
            rentaRepo.saveNewRentabilitySimulation(name: name, project: project, rentaRepo: rentaRepo)
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
        projectNameTextField.resignFirstResponder()
    }
    
}

//MARK: - Extension

/// Extension of AddRentabilityToNewProjectPopUpVC for textfield delegate methods
extension AddRentabilityToNewProjectPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
    }
}
