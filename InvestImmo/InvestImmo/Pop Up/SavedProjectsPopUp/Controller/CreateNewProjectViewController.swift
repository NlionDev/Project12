//
//  CreateNewProjectViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class CreateNewProjectViewController: UIViewController {
    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let projectRepository = ProjectRepository()
    
    //MARK: - Outlets
    @IBOutlet weak private var newProjectTextField: UITextField!
    
    //MARK: - Actions
    @IBAction private func didTapOnCreateNewProjectButton(_ sender: Any) {
        guard let name = newProjectTextField.text else {return}
        if isMyProjectNameUnique(name: name, projects: projectRepository.myProjects) {
            projectRepository.saveEmptyNewProject(name: name)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.reloadSavedProjects.name), object: nil)
            dismiss(animated: true)
        } else {
            let alert = errorAlert.alert(message: popUpProjectAlreadyExistMessage)
            present(alert, animated: true)
        }
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        newProjectTextField.resignFirstResponder()
    }
    
}

//MARK: - Extension
extension CreateNewProjectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newProjectTextField.resignFirstResponder()
    }
}
