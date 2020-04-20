//
//  Alerts.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class ChecklistExistantProjectAlert {
    
    func alert(checklist: ChecklistRepository) -> AddChecklistToExistantProjectAlertVC {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ChecklistExistantProjectAlertVC") as! AddChecklistToExistantProjectAlertVC
        alertVC.checklistRepo = checklist
        return alertVC
    }
}

class ChecklistNewProjectAlert {
    
    func alert(checklist: ChecklistRepository) -> AddChecklistToNewProjectAlertVC {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ChecklistNewProjectAlertVC") as! AddChecklistToNewProjectAlertVC
        alertVC.checklistRepo = checklist
        return alertVC
    }
}

class RentabilityNewProjectAlert {
    
    func alert(rentability: RentabilityRepository) -> AddRentabilityToNewProjectAlertVC {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "RentabilityNewProjectAlertVC") as! AddRentabilityToNewProjectAlertVC
        alertVC.rentaRepo = rentability
        return alertVC
    }
}

class RentabilityExistantProjectAlert {
    
    func alert(rentability: RentabilityRepository) -> AddRentabilityToExistantProjectAlertVC {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "RentabilityExistantProjectAlertVC") as! AddRentabilityToExistantProjectAlertVC
        alertVC.rentaRepo = rentability
        return alertVC
    }
}

class CreditNewProjectAlert {
    
    func alert(credit: CreditRepository) -> AddCreditToNewProjectAlertVC {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CreditNewProjectAlertVC") as! AddCreditToNewProjectAlertVC
        alertVC.creditRepo = credit
        return alertVC
    }
}

class CreditExistantProjectAlert {
    
    func alert(credit: CreditRepository) -> AddCreditToExistantProjectAlertVC {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CreditExistantProjectAlertVC") as! AddCreditToExistantProjectAlertVC
        alertVC.creditRepo = credit
        return alertVC
    }
}

class ErrorAlert {
    
    func alert(message: String) -> ErrorAlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ErrorAlertVC") as! ErrorAlertViewController
        alertVC.message = message
        return alertVC
    }
}
