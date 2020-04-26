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
    private let realmRepo = RealmRepository()
    private let project = Project()
    
    //MARK: - Outlets
    
    @IBOutlet weak var newProjectTextField: UITextField!
    
    //MARK: - Actions
    
    @IBAction func didTapOnCreateNewProjectButton(_ sender: Any) {
        guard let name = newProjectTextField.text else {return}
        if isMyProjectNameUnique(name: name, projects: realmRepo.myProjects) {
            realmRepo.saveEmptyNewProject(name: name)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadSavedProjectsData"), object: nil)
            dismiss(animated: true)
        } else {
            let alert = errorAlert.alert(message: "Un projet existant porte déjà ce nom.")
            present(alert, animated: true)
        }
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
