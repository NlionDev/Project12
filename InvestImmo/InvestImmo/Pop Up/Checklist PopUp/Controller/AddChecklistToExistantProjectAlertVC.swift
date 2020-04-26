//
//  ChecklistAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class AddChecklistToExistantProjectAlertVC: UIViewController {

    
    //MARK: - Properties
    
    private let errorAlert = ErrorAlert()
    private let newProjectAlert = ChecklistNewProjectAlert()
    private let realmRepo = RealmRepository()
    private var selectedProject: Project?
    private var checklistGeneral = ChecklistGeneral()
    private var checklistDistrict = ChecklistDistrict()
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    private var checklistApartment = ChecklistApartment()
    var checklistRepo: ChecklistRepository?
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var alertTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnCreateNewProject(_ sender: Any) {
        guard let checklistRepo = checklistRepo else {return}
        dismiss(animated: true) {
            let alertVC = self.newProjectAlert.alert(checklist: checklistRepo)
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: Notification.Name(rawValue: "DismissPreviousAlert"), object: nil)
            self.present(alertVC, animated: true)
        }
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    
    private func checkIfTheProjectAlreadyHaveSavedChecklist(project: Project) -> Bool {
        var result = true
        if let projectName = project.name {
            let checklists = realmRepo.realm.objects(ChecklistGeneral.self).filter("name = '\(projectName)'")
            if checklists.isEmpty {
                result = false
            } else {
                result = true
            }
        }
        return result
    }
    
    @objc func hideAlertController() {
        self.dismiss(animated: true)
    }

}

//MARK: - Extensions

extension AddChecklistToExistantProjectAlertVC: UITableViewDataSource, UITableViewDelegate {


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return realmRepo.myProjects.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistAlertCell", for: indexPath) as? ExistantProjectAlertTableViewCell else {
        
        return UITableViewCell()
    }
    if let projectName = realmRepo.myProjects[indexPath.row].name {
        cell.configure(projectName: projectName)
    }
    return cell
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = realmRepo.myProjects[indexPath.row]
        guard let project = selectedProject else {return}
        guard let name = project.name else {return}
        guard let checklistRepo = checklistRepo else {return}
        if checkIfTheProjectAlreadyHaveSavedChecklist(project: project) {
            let alert = errorAlert.alert(message: "Ce projet possède déjà une check-list.")
            present(alert, animated: true)
        } else {
            checklistRepo.addChecklistGeneralToExistantProject(project: project, checklistGeneral: checklistGeneral, realmRepo: realmRepo, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistDistrict(name: name, checklistDistrict: checklistDistrict, realmRepo: realmRepo, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartmentBlock(name: name, checklistApartmentBlock: checklistApartmentBlock, realmRepo: realmRepo, checklistRepo: checklistRepo)
            checklistRepo.saveChecklistApartment(name: name, checklistApartment: checklistApartment, realmRepo: realmRepo, checklistRepo: checklistRepo)
            dismiss(animated: true)
        }
        
    }
}
