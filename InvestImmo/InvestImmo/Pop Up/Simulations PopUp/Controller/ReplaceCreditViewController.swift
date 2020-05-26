//
//  ReplaceCreditViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for ReplaceCreditViewController
class ReplaceCreditViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Property to store CreditRepository past from viewcontroller who present the pop up
    var creditRepository: CreditRepository?
    
    /// Property to store Project past from viewcontroller who present the pop up
    var selectedProject: Project?

    //MARK: - Actions
    
    /// Action activated when tap on yes button for delete previous credit and save new credit to the selected project
    @IBAction private func didTapOnYesButton(_ sender: Any) {
        guard let creditRepository = creditRepository,
            let realm = creditRepository.realm,
            let project = selectedProject,
            let projectName = project.name else {return}
        let creditToDelete = realm.objects(CreditSimulation.self).filter("name = '\(projectName)'")
        creditRepository.deleteCreditSimulation(creditToDelete: creditToDelete)
        creditRepository.addCreditSimulationToExistantProject(project: project, creditRepo: creditRepository)
         dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.dismissFromReplace.name), object: nil)
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
