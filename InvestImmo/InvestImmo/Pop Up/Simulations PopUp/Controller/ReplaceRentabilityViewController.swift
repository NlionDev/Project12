//
//  ReplaceRentabilityViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ReplaceRentabilityViewController: UIViewController {
    
    //MARK: - Properties
    var rentabilityRepository: RentabilityRepository?
    var selectedProject: Project?
    
    //MARK: - Actions
    @IBAction private func didTapOnYesButton(_ sender: Any) {
        guard let rentabilityRepository = rentabilityRepository,
            let realm = rentabilityRepository.realm,
            let project = selectedProject,
            let projectName = project.name else {return}
        let rentabilityToDelete = realm.objects(RentabilitySimulation.self).filter("name = '\(projectName)'")
        rentabilityRepository.deleteRentabilitySimulation(rentabilityToDelete: rentabilityToDelete)
        rentabilityRepository.addRentabilitySimulationToExistantProject(project: project, rentaRepo: rentabilityRepository)
         dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissAlertFromReplaceVC"), object: nil)
    }
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
