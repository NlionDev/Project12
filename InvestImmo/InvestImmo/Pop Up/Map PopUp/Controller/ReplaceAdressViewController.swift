//
//  ReplaceAdressViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for ReplaceAdressViewController
class ReplaceAdressViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of MapRepository
    private let mapRepository = MapRepository()
    
    /// Property for store project selected by user
    var selectedProject: Project?
    
    /// Property for store adress past from viewcontroller who present the pop up
    var adress: String?
    
    /// Property for store latitude past from viewcontroller who present the pop up
    var latitude: String?
    
    /// Property for store longitude past from viewcontroller who present the pop up
    var longitude: String?

    //MARK: - Actions
    
    /// Action activated when tap on yes button for delete previous map adress and save new map adress to the selected project
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
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
