//
//  AddCreditToExistantProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddCreditToExistantProjectPopUpVC: UIViewController {
    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let replaceCreditPopUp = ReplaceCreditPopUp()
    private let creditNewProjectPopUp = CreditNewProjectPopUp()
    private let simulation = CreditSimulation()
    private var selectedProject: Project?
    private let projectRepository = ProjectRepository()
    var creditRepository: CreditRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var alertTableView: UITableView!
    
    //MARK: - Actions
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let creditRepo = creditRepository else {return}
        let alert = creditNewProjectPopUp.alert(credit: creditRepo)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissPreviousAlert"), object: nil)
        present(alert, animated: true)
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
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
    
    @objc private func hideAlertController() {
        self.dismiss(animated: true)
    }
}

//MARK: - Extension
extension AddCreditToExistantProjectPopUpVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectRepository.myProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExistantProjectAlertCell", for: indexPath) as? ExistantProjectAlertTableViewCell else {
            
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
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissAlertFromReplaceVC"), object: nil)
            let alert = replaceCreditPopUp.alert(project: project, credit: creditRepository)
            present(alert, animated: true)
        } else {
            creditRepository.addCreditSimulationToExistantProject(project: project, creditRepo: creditRepository)
            dismiss(animated: true)
        }
    }
}
