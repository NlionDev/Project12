//
//  AddCreditToNewProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddCreditToNewProjectPopUpVC: UIViewController {
    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let projectRepository = ProjectRepository()
    private let project = Project()
    var creditRepository: CreditRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var projectTextField: UITextField!
    
    
    //MARK: - Actions
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectTextField.text,
            let creditRepo = creditRepository else {return}
        if projectRepository.isMyProjectNameUnique(name: name) {
            creditRepo.saveNewCreditSimulation(name: name, project: project, creditRepo: creditRepo)
            dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.dismissFromPrevious.name), object: nil)
        } else {
            let alert = errorAlert.alert(message: PopUpAlertMessage.projectAlreadyExist.message)
            present(alert, animated: true)
        }
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        projectTextField.resignFirstResponder()
    }
    
}

//MARK: - Extension
extension AddCreditToNewProjectPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectTextField.resignFirstResponder()
    }
}
