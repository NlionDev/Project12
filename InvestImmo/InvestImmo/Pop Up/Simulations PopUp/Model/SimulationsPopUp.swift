//
//  SimulationsPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class RentabilityNewProjectAlert {
    
    func alert(rentability: RentabilityRepository) -> AddRentabilityToNewProjectAlertVC {
        let storyboard = UIStoryboard(name: "SimulationsPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "RentabilityNewProjectAlertVC") as! AddRentabilityToNewProjectAlertVC
        alertVC.rentaRepo = rentability
        return alertVC
    }
}

class RentabilityExistantProjectAlert {
    
    func alert(rentability: RentabilityRepository) -> AddRentabilityToExistantProjectAlertVC {
        let storyboard = UIStoryboard(name: "SimulationsPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "RentabilityExistantProjectAlertVC") as! AddRentabilityToExistantProjectAlertVC
        alertVC.rentaRepo = rentability
        return alertVC
    }
}

class CreditNewProjectAlert {
    
    func alert(credit: CreditRepository) -> AddCreditToNewProjectAlertVC {
        let storyboard = UIStoryboard(name: "SimulationsPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CreditNewProjectAlertVC") as! AddCreditToNewProjectAlertVC
        alertVC.creditRepo = credit
        return alertVC
    }
}

class CreditExistantProjectAlert {
    
    func alert(credit: CreditRepository) -> AddCreditToExistantProjectAlertVC {
        let storyboard = UIStoryboard(name: "SimulationsPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CreditExistantProjectAlertVC") as! AddCreditToExistantProjectAlertVC
        alertVC.creditRepo = credit
        return alertVC
    }
}
