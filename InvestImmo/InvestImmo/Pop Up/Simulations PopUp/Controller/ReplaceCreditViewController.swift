//
//  ReplaceCreditViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ReplaceCreditViewController: UIViewController {
    
    //MARK: - Properties
    var creditRepository: CreditRepository?
    var selectedProject: Project?

    //MARK: - Actions
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
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
    }
    
}
