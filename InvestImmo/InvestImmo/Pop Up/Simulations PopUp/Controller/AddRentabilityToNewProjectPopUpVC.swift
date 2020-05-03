//
//  AddRentabilityToNewProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddRentabilityToNewProjectPopUpVC: UIViewController {

    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let projectRepository = ProjectRepository()
    private let project = Project()
    var rentabilityRepository: RentabilityRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var projectNameTextField: UITextField!
    
    //MARK: - Actions
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectNameTextField.text,
            let rentaRepo = rentabilityRepository else {return}
        if isMyProjectNameUnique(name: name, projects: projectRepository.myProjects) {
            rentaRepo.saveNewRentabilitySimulation(name: name, project: project, rentaRepo: rentaRepo)
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
        projectNameTextField.resignFirstResponder()
    }
    
}

//MARK: - Extension
extension AddRentabilityToNewProjectPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
    }
}
