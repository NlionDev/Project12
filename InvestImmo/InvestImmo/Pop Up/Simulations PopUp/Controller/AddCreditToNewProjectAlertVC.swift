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
        if isMyProjectNameUnique(name: name, projects: projectRepository.myProjects) {
            creditRepo.saveNewCreditSimulation(name: name, project: project, creditRepo: creditRepo)
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

}
