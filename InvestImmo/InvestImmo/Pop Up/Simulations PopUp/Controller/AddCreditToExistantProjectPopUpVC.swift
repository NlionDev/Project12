//
//  AddCreditToExistantProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for AddCreditToExistantProjectPopUpVC
class AddCreditToExistantProjectPopUpVC: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of ErrorAlert for present alert
    private let errorAlert = ErrorAlert()
    
    /// Instance of ReplaceCreditPopUp
    private let replaceCreditPopUp = ReplaceCreditPopUp()
    
    /// Instance CreditNewProjectPopUp
    private let creditNewProjectPopUp = CreditNewProjectPopUp()
    
    /// Property for store project selected by user
    private var selectedProject: Project?
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Instance of CreditRepository past from viewcontroller who present the pop up
    var creditRepository: CreditRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var alertTableView: UITableView!
    
    //MARK: - Actions
    
    /// Action activated  when tap on new project button for present new project pop up
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let creditRepo = creditRepository else {return}
        let alert = creditNewProjectPopUp.alert(credit: creditRepo)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: PopUpNotification.dismissFromPrevious.name), object: nil)
        present(alert, animated: true)
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    
    /// Method for check if the selected project already have credit simulation
    private func checkIfTheProjectAlreadyHaveSavedCreditSimulation(project: Project) -> Bool {
        var result = true
        if let projectName = project.name,
            let creditRepository = creditRepository,
            let realm = creditRepository.realm {
            let simulations = realm.objects(CreditSimulation.self).filter("name = '\(projectName)'")
            if simulations.isEmpty {
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

//MARK: - Extension

/// Extension of AddCreditToExistantProjectPopUpVC for tableview delegate and datasource methods
extension AddCreditToExistantProjectPopUpVC: UITableViewDataSource, UITableViewDelegate {
    
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
        let creditRepository = creditRepository else {return}
        if checkIfTheProjectAlreadyHaveSavedCreditSimulation(project: project) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
            let alert = replaceCreditPopUp.alert(project: project, credit: creditRepository)
            present(alert, animated: true)
        } else {
            creditRepository.addCreditSimulationToExistantProject(project: project, creditRepo: creditRepository)
            dismiss(animated: true)
        }
    }
}
