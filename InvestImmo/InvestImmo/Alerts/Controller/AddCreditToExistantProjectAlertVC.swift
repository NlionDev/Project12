//
//  AddCreditToExistantProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddCreditToExistantProjectAlertVC: UIViewController {
    
    //MARK: - Properties
    
    private let errorAlert = ErrorAlert()
    private let creditNewProjectAlert = CreditNewProjectAlert()
    private let simulation = CreditSimulation()
    private let project = Project()
    private var selectedProject: Project?
    private let realmRepo = RealmRepository()
    var creditRepo: CreditRepository?
    
    //MARK: - Outlets
    
    @IBOutlet weak var alertTableView: UITableView!
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewProjectButton(_ sender: Any) {
        guard let creditRepo = creditRepo else {return}
        let alert = creditNewProjectAlert.alert(credit: creditRepo)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissPreviousAlert"), object: nil)
        present(alert, animated: true)
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    //MARK: - Methods
    
    private func checkIfTheProjectAlreadyHaveSavedCreditSimulation(project: Project) -> Bool {
        var result = true
        if let projectName = project.name {
            let simulations = realmRepo.realm.objects(CreditSimulation.self).filter("name = '\(projectName)'")
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

extension AddCreditToExistantProjectAlertVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmRepo.myProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExistantProjectAlertCell", for: indexPath) as? ExistantProjectAlertTableViewCell else {
            
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
        guard let creditRepo = creditRepo else {return}
        if checkIfTheProjectAlreadyHaveSavedCreditSimulation(project: project) {
            let alert = errorAlert.alert(message: "Ce projet possède déjà une simulation de crédit.")
            present(alert, animated: true)
        } else {
            creditRepo.addCreditSimulationToExistantProject(project: project, simulation: simulation, realmRepo: realmRepo, creditRepo: creditRepo)
            dismiss(animated: true)
        }
    }
}
