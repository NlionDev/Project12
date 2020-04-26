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
    private let newProjectPopUp = MapNewProjectAlert()
    private let errorAlert = ErrorAlert()
    private var selectedProject: Project?
    private let realmRepo = RealmRepository()
    var adress: String?
    var latitude: String?
    var longitude: String?
    
    //MARK: - Outlets
    @IBOutlet weak var existantProjectsTableView: UITableView!
    
    //MARK: - Actions
    
    @IBAction func didTapOnNewProjectButton(_ sender: Any) {
        guard let adress = self.adress,
            let latitude = self.latitude,
            let longitude = self.longitude else {return}
        let alert = self.newProjectPopUp.alert(adress: adress, latitude: latitude, longitude: longitude)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideAlertController), name: NSNotification.Name(rawValue: "DismissFirstAlert"), object: nil)
        self.present(alert, animated: true)
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    

    //MARK: - Methods
    
    private func checkIfTheProjectAlreadyHaveSavedAdress(project: Project) -> Bool {
        var result = true
        if let projectName = project.name {
            let adresses = realmRepo.realm.objects(MapAdress.self).filter("name = '\(projectName)'")
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
        if checkIfTheProjectAlreadyHaveSavedAdress(project: project) {
            let alert = errorAlert.alert(message: "Ce projet possède déjà une adresse de bien.")
            present(alert, animated: true)
        } else {
            guard let name = project.name,
                let adress = adress,
                let latitude = latitude,
                let longitude = longitude else {return}
            realmRepo.saveMapAdressInExistantProject(name: name, adress: adress, latitude: latitude, longitude: longitude)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConfigureMapView"), object: nil)
            dismiss(animated: true)
        }
    }
}

