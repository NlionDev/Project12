//
//  AddRentabilityToExistantProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddRentabilityToExistantProjectAlertVC: UIViewController {

    
    //MARK: - Properties
    
    private let errorAlert = ErrorAlert()
    private let rentaNewProjectAlert = RentabilityNewProjectAlert()
    private let simulation = RentabilitySimulation()
    private let project = Project()
    private var selectedProject: Project?
    private let realmRepo = RealmRepository()
    var rentaRepo: RentabilityRepository?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var alertTableView: UITableView!
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewProjectButton(_ sender: Any) {
        guard let rentaRepo = rentaRepo else {return}
        dismiss(animated: true, completion: {
            let alert = self.rentaNewProjectAlert.alert(rentability: rentaRepo)
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissPreviousAlert"), object: nil)
            self.present(alert, animated: true)
        })
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    //MARK: - Methods

    private func checkIfTheProjectAlreadyHaveSavedRentabilitySimulation(project: Project) -> Bool {
        var result = true
        if let projectName = project.name {
            let simulations = realmRepo.realm.objects(RentabilitySimulation.self).filter("name = '\(projectName)'")
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

//MARK: - Extensions

extension AddRentabilityToExistantProjectAlertVC: UITableViewDataSource, UITableViewDelegate {
    
    
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
        guard let rentaRepo = rentaRepo else {return}
        if checkIfTheProjectAlreadyHaveSavedRentabilitySimulation(project: project) {
            let alert = errorAlert.alert(message: "Ce projet possède déjà une simulation de rentabilité.")
            present(alert, animated: true)
        } else {
            rentaRepo.addRentabilitySimulationToExistantProject(project: project, simulation: simulation, realmRepo: realmRepo, rentaRepo: rentaRepo)
            dismiss(animated: true)
        }
    }
}
