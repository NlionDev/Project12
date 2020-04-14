//
//  Alerts.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class ExistantProjectAlert {
    
    func alert(checklist: ChecklistRepository, simulation: RentabilitySimulation) -> ChecklistAlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ExistantProjectAlertVC") as! ChecklistAlertViewController
        alertVC.mySimulationData = simulation
        alertVC.checklistData = checklist
        return alertVC
    }
}

class NewProjectAlert {
    
    func alert(checklist: ChecklistRepository, simulation: RentabilitySimulation) -> AddNewProjectAlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "NewProjectAlertVC") as! AddNewProjectAlertViewController
        alertVC.mySimulationData = simulation
        alertVC.checklistData = checklist
        return alertVC
    }
}
