//
//  ReplaceAdressViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ReplaceAdressViewController: UIViewController {
    
    //MARK: - Properties
    private let mapRepository = MapRepository()
    var selectedProject: Project?
    var adress: String?
    var latitude: String?
    var longitude: String?

    //MARK: - Actions
    @IBAction private func didTapOnYesButton(_ sender: Any) {
        guard let realm = mapRepository.realm,
            let project = selectedProject,
            let projectName = project.name,
            let adress = adress,
            let latitude = latitude,
            let longitude = longitude else {return}
        let adressToDelete = realm.objects(MapAdress.self).filter("name = '\(projectName)'")
        mapRepository.deleteProjectAdress(adressToDelete: adressToDelete)
        mapRepository.saveMapAdressInExistantProject(name: projectName, adress: adress, latitude: latitude, longitude: longitude)
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
