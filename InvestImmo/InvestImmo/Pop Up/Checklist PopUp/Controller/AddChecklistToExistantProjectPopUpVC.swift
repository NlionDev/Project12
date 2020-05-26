//
//  ChecklistAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

/// Class for AddChecklistToExistantProjectPopUpVC
class AddChecklistToExistantProjectPopUpVC: UIViewController {

    
    //MARK: - Properties
    
    /// Instance of ReplaceProjectChecklistPopUp
    private let replaceProjectChecklistPopUp = ReplaceProjectChecklistPopUp()
    
    /// Instance of ChecklistNewProjectPopUp
    private let newProjectPopUp = ChecklistNewProjectPopUp()
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Property for store project selected by user
    private var selectedProject: Project?
    
    /// Instance of ChecklistRepository past from viewcontroller who present the pop up
    var checklistRepository: ChecklistRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var alertTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTableView.reloadData()
    }
    
    //MARK: - Actions
    
    /// Action activated  when tap on new project button for present new project pop up
    @IBAction private func didTapOnCreateNewProject(_ sender: Any) {
        guard let checklistRepo = checklistRepository else {return}
        let alertVC = self.newProjectPopUp.alert(checklist: checklistRepo)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: Notification.Name(rawValue: PopUpNotification.dismissFromPrevious.name), object: nil)
        self.present(alertVC, animated: true)
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    
    /// Method for check if the selected project already have checklist
    private func checkIfTheProjectAlreadyHaveSavedChecklist(project: Project) -> Bool {
        var result = true
        if let projectName = project.name,
            let checklistRepository = checklistRepository,
            let realm = checklistRepository.realm {
            let checklists = realm.objects(ChecklistGeneral.self).filter("name = '\(projectName)'")
            if checklists.isEmpty {
                result = false
            } else {
                result = true
            }
        }
        return result
    }
    
    /// Method for dismiss viewController
    @objc private func hideAlertController() {
        self.dismiss(animated: true)
    }

}

//MARK: - Extensions

/// Extension of AddChecklistToExistantProjectPopUpVC for tableview delegate and datasource methods
extension AddChecklistToExistantProjectPopUpVC: UITableViewDataSource, UITableViewDelegate {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projectRepository.myProjects.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: existantProjectCellIdentifier, for: indexPath) as? ExistantProjectAlertTableViewCell else {
        
        return UITableViewCell()
    }
    if let projectName = projectRepository.myProjects[indexPath.row].name {
        cell.configure(projectName: projectName)
    }
    return cell
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = projectRepository.myProjects[indexPath.row]
        guard let project = selectedProject,
            let name = project.name,
            let checklistRepository = checklistRepository else {return}
        if checkIfTheProjectAlreadyHaveSavedChecklist(project: project) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
            let alert = replaceProjectChecklistPopUp.alert(project: project, checklist: checklistRepository)
            present(alert, animated: true)
        } else {
            checklistRepository.saveChecklistGeneralToExistantProject(project: project, checklistRepo: checklistRepository)
            checklistRepository.saveChecklistDistrict(name: name, checklistRepo: checklistRepository)
            checklistRepository.saveChecklistApartmentBlock(name: name, checklistRepo: checklistRepository)
            checklistRepository.saveChecklistApartment(name: name, checklistRepo: checklistRepository)
            dismiss(animated: true)
        }
    }
}
