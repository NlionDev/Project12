//
//  AddRentabilityToExistantProjectAlertVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddRentabilityToExistantProjectPopUpVC: UIViewController {

    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let rentaNewProjectAlert = RentabilityNewProjectPopUp()
    private let replaceRentabilityPopUp = ReplaceRentabilityPopUp()
    private let projectRepository = ProjectRepository()
    private var selectedProject: Project?
    var rentabilityRepository: RentabilityRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var alertTableView: UITableView!
    
    //MARK: - Actions
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let rentaRepo = rentabilityRepository else {return}
        dismiss(animated: true, completion: {
            let alert = self.rentaNewProjectAlert.alert(rentability: rentaRepo)
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissPreviousAlert"), object: nil)
            self.present(alert, animated: true)
        })
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    private func checkIfTheProjectAlreadyHaveSavedRentabilitySimulation(project: Project) -> Bool {
        var result = true
        if let rentabilityRepository = rentabilityRepository,
            let realm = rentabilityRepository.realm,
            let projectName = project.name {
            let simulations = realm.objects(RentabilitySimulation.self).filter("name = '\(projectName)'")
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
extension AddRentabilityToExistantProjectPopUpVC: UITableViewDataSource, UITableViewDelegate {
    
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
            let rentaRepo = rentabilityRepository else {return}
        if checkIfTheProjectAlreadyHaveSavedRentabilitySimulation(project: project) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
            let alert = replaceRentabilityPopUp.alert(project: project, rentability: rentaRepo)
            present(alert, animated: true)
        } else {
            rentaRepo.addRentabilitySimulationToExistantProject(project: project, rentaRepo: rentaRepo)
            dismiss(animated: true)
        }
    }
}
