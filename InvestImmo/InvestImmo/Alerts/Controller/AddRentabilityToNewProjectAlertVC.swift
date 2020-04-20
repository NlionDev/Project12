//
//  AddRentabilityToNewProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddRentabilityToNewProjectAlertVC: UIViewController {

    //MARK: - Properties
    
    private let errorAlert = ErrorAlert()
    private let realmRepo = RealmRepository()
    private let simulation = RentabilitySimulation()
    private let project = Project()
    var rentaRepo: RentabilityRepository?
    
    //MARK: - Outlets
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectNameTextField.text else {return}
        guard let rentaRepo = rentaRepo else {return}
        if isMyProjectNameUnique(name: name, projects: realmRepo.myProjects) {
            rentaRepo.saveNewRentabilitySimulation(name: name, simulation: simulation, project: project, realmRepo: realmRepo, rentaRepo: rentaRepo)
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
