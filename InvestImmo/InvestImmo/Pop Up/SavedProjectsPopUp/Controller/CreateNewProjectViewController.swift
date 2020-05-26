//
//  CreateNewProjectViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for CreateNewProjectViewController
class CreateNewProjectViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of ErrorAlert for present alert
    private let errorAlert = ErrorAlert()
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    //MARK: - Outlets
    @IBOutlet weak private var newProjectTextField: UITextField!
    
    //MARK: - Actions
    
    /// Action activated when tap on new project button for save new project
    @IBAction private func didTapOnCreateNewProjectButton(_ sender: Any) {
        guard let name = newProjectTextField.text else {return}
        if projectRepository.isMyProjectNameUnique(name: name) {
            projectRepository.saveEmptyNewProject(name: name)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.reloadSavedProjects.name), object: nil)
            dismiss(animated: true)
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
        newProjectTextField.resignFirstResponder()
    }
    
}

//MARK: - Extension

/// Extension of CreateNewProjectViewController for textfield delegate method
extension CreateNewProjectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newProjectTextField.resignFirstResponder()
    }
}
