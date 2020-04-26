//
//  ChecklistPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ChecklistExistantProjectAlert {
    
    func alert(checklist: ChecklistRepository) -> AddChecklistToExistantProjectAlertVC {
        let storyboard = UIStoryboard(name: "ChecklistPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ChecklistExistantProjectAlertVC") as! AddChecklistToExistantProjectAlertVC
        alertVC.checklistRepo = checklist
        return alertVC
    }
}

class ChecklistNewProjectAlert {
    
    func alert(checklist: ChecklistRepository) -> AddChecklistToNewProjectAlertVC {
        let storyboard = UIStoryboard(name: "ChecklistPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ChecklistNewProjectAlertVC") as! AddChecklistToNewProjectAlertVC
        alertVC.checklistRepo = checklist
        return alertVC
    }
}
