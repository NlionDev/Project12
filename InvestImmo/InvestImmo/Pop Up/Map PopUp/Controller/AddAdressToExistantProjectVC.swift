//
//  AddAdressToExistantProjectVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for AddAdressToExistantProjectVC
class AddAdressToExistantProjectVC: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of MapRepository
    private let mapRepository = MapRepository()
    
    /// Instance of MapNewProjectPopUp
    private let newProjectPopUp = MapNewProjectPopUp()
    
    /// Instance of ReplaceProjectAdressPopUp
    private let replaceProjectAdressPopUp = ReplaceProjectAdressPopUp()
    
    /// Property for store project selected by user
    private var selectedProject: Project?
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Property for store adress past from viewcontroller who present the pop up
    var adress: String?
    
    /// Property for store latitude past from viewcontroller who present the pop up
    var latitude: String?
    
    /// Property for store longitude past from viewcontroller who present the pop up
    var longitude: String?
    
    //MARK: - Outlets
    @IBOutlet weak private var existantProjectsTableView: UITableView!
    
    //MARK: - Actions
    
    /// Action activated  when tap on new project button for present new project pop up
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let adress = self.adress,
            let latitude = self.latitude,
            let longitude = self.longitude else {return}
        let alert = self.newProjectPopUp.alert(adress: adress, latitude: latitude, longitude: longitude)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: PopUpNotification.dismissFisrtAlert.name), object: nil)
        self.present(alert, animated: true)
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    

    //MARK: - Methods
    
    /// Method for check if the selected project already have map adress
    private func checkIfTheProjectAlreadyHaveSavedAdress(project: Project) -> Bool {
        var result = true
        if let realm = mapRepository.realm,
            let projectName = project.name {
            let adresses = realm.objects(MapAdress.self).filter("name = '\(projectName)'")
            if adresses.isEmpty {
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

/// Extension of AddAdressToExistantProjectVC for tableview delegate and datasource methods
extension AddAdressToExistantProjectVC: UITableViewDataSource, UITableViewDelegate {
    
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
        let adress = adress,
        let latitude = latitude,
        let longitude = longitude else {return}
        if checkIfTheProjectAlreadyHaveSavedAdress(project: project) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
            let alert = replaceProjectAdressPopUp.alert(project: project, adress: adress, latitude: latitude, longitude: longitude)
            present(alert, animated: true)
        } else {
            mapRepository.saveMapAdressInExistantProject(name: name, adress: adress, latitude: latitude, longitude: longitude)
            dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.configureMapView.name), object: nil)
        }
    }
}

