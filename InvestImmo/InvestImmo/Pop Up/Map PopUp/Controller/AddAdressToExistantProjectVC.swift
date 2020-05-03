//
//  AddAdressToExistantProjectVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddAdressToExistantProjectVC: UIViewController {
    
    //MARK: - Properties
    private let mapRepository = MapRepository()
    private let newProjectPopUp = MapNewProjectPopUp()
    private let replaceProjectAdressPopUp = ReplaceProjectAdressPopUp()
    private var selectedProject: Project?
    private let projectRepository = ProjectRepository()
    var adress: String?
    var latitude: String?
    var longitude: String?
    
    //MARK: - Outlets
    @IBOutlet weak private var existantProjectsTableView: UITableView!
    
    //MARK: - Actions
    @IBAction private func didTapOnNewProjectButton(_ sender: Any) {
        guard let adress = self.adress,
            let latitude = self.latitude,
            let longitude = self.longitude else {return}
        let alert = self.newProjectPopUp.alert(adress: adress, latitude: latitude, longitude: longitude)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissFirstAlert"), object: nil)
        self.present(alert, animated: true)
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    

    //MARK: - Methods
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
    
    @objc private func hideAlertController() {
        self.dismiss(animated: true)
    }

}


//MARK: - Extension
extension AddAdressToExistantProjectVC: UITableViewDataSource, UITableViewDelegate {
    
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
        let name = project.name,
        let adress = adress,
        let latitude = latitude,
        let longitude = longitude else {return}
        if checkIfTheProjectAlreadyHaveSavedAdress(project: project) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissAlertFromReplaceVC"), object: nil)
            let alert = replaceProjectAdressPopUp.alert(project: project, adress: adress, latitude: latitude, longitude: longitude)
            present(alert, animated: true)
        } else {
            mapRepository.saveMapAdressInExistantProject(name: name, adress: adress, latitude: latitude, longitude: longitude)
            dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConfigureMapView"), object: nil)
        }
    }
}

