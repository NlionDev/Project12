//
//  AddCreditToNewProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddCreditToNewProjectAlertVC: UIViewController {
    
    //MARK: - Properties
    
    private let errorAlert = ErrorAlert()
    private let realmRepo = RealmRepository()
    private let simulation = CreditSimulation()
    private let project = Project()
    var creditRepo: CreditRepository?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var projectTextField: UITextField!
    
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectTextField.text else {return}
        guard let creditRepo = creditRepo else {return}
         if isMyProjectNameUnique(name: name, projects: realmRepo.myProjects) {
            creditRepo.saveNewCreditSimulation(name: name, simulation: simulation, project: project, realmRepo: realmRepo, creditRepo: creditRepo)
             dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissPreviousAlert"), object: nil)
         } else {
             let alert = errorAlert.alert(message: "Un projet existant porte déjà ce nom.")
             present(alert, animated: true)
         }
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
