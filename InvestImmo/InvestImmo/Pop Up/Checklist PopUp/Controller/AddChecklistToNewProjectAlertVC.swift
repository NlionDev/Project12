//
//  AddNewProjectAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 05/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class AddChecklistToNewProjectAlertVC: UIViewController {

    
    //MARK: - Properties

    private let errorAlert = ErrorAlert()
    private let realmRepo = RealmRepository()
    private var project = Project()
    private var checklistGeneral = ChecklistGeneral()
    private var checklistDistrict = ChecklistDistrict()
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    private var checklistApartment = ChecklistApartment()
    var checklistRepo: ChecklistRepository?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var projectNameLabel: UITextField!
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewProjectButton(_ sender: Any) {
        guard let name = projectNameLabel.text else {return}
        guard let checklistRepo = checklistRepo else {return}
        if isMyProjectNameUnique(name: name, projects: realmRepo.myProjects) {
            checklistRepo.saveNewChecklistGeneral(name: name, project: project, checklistGeneral: checklistGeneral, realmRepo: realmRepo, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistDistrict(name: name, checklistDistrict: checklistDistrict, realmRepo: realmRepo, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartmentBlock(name: name, checklistApartmentBlock: checklistApartmentBlock, realmRepo: realmRepo, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartment(name: name, checklistApartment: checklistApartment, realmRepo: realmRepo, checklistRepo: checklistRepo)
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
