//
//  ChecklistAlertService.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ExistantProjectAlertService {
    
    @available(iOS 13.0, *)
    func alert(checklist: ChecklistData, simulation: RentabilitySimulation) -> ChecklistAlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(identifier: "ExistantProjectAlertVC") as! ChecklistAlertViewController
        alertVC.mySimulationData = simulation
        alertVC.checklistData = checklist
        return alertVC
    }
}

class NewProjectAlertService {
    @available(iOS 13.0, *)
    func alert(checklist: ChecklistData, simulation: RentabilitySimulation) -> AddNewProjectAlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(identifier: "NewProjectAlertVC") as! AddNewProjectAlertViewController
        alertVC.mySimulationData = simulation
        alertVC.checklistData = checklist
        return alertVC
    }
}
