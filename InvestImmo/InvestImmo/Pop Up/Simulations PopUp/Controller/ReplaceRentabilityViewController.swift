//
//  ReplaceRentabilityViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for ReplaceRentabilityViewController
class ReplaceRentabilityViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Property to store RentabilityRepository past from viewcontroller who present the pop up
    var rentabilityRepository: RentabilityRepository?
    
    /// Property to store Project past from viewcontroller who present the pop up
    var selectedProject: Project?
    
    //MARK: - Actions
    
    /// Action activated when tap on yes button for delete previous rentability and save new rentability to the selected project
    @IBAction private func didTapOnYesButton(_ sender: Any) {
        guard let rentabilityRepository = rentabilityRepository,
            let realm = rentabilityRepository.realm,
            let project = selectedProject,
            let projectName = project.name else {return}
        let rentabilityToDelete = realm.objects(RentabilitySimulation.self).filter("name = '\(projectName)'")
        rentabilityRepository.deleteRentabilitySimulation(rentabilityToDelete: rentabilityToDelete)
        rentabilityRepository.addRentabilitySimulationToExistantProject(project: project, rentaRepo: rentabilityRepository)
         dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
