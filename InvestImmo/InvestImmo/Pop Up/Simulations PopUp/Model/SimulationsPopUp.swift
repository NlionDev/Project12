//
//  SimulationsPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for RentabilityNewProjectPopUp
class RentabilityNewProjectPopUp {
    
    /// Method for instatiate AddRentabilityToNewProjectPopUpVC and present alert
    func alert(rentability: RentabilityRepository) -> AddRentabilityToNewProjectPopUpVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.simulations.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: SimulationsVC.rentabilityNewProject.identifier) as! AddRentabilityToNewProjectPopUpVC
        alertVC.rentabilityRepository = rentability
        return alertVC
    }
}

/// Class for RentabilityExistantProjectPopUp
class RentabilityExistantProjectPopUp {
    
    /// Method for instatiate AddRentabilityToExistantProjectPopUpVC and present alert
    func alert(rentability: RentabilityRepository) -> AddRentabilityToExistantProjectPopUpVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.simulations.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: SimulationsVC.rentabilityExistantProject.identifier) as! AddRentabilityToExistantProjectPopUpVC
        alertVC.rentabilityRepository = rentability
        return alertVC
    }
}

/// Class for ReplaceRentabilityPopUp
class ReplaceRentabilityPopUp {
    
    /// Method for instatiate ReplaceRentabilityViewController and present alert
    func alert(project: Project, rentability: RentabilityRepository) -> ReplaceRentabilityViewController {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.simulations.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: SimulationsVC.rentabilityReplaceProject.identifier) as! ReplaceRentabilityViewController
        alertVC.rentabilityRepository = rentability
        alertVC.selectedProject = project
        return alertVC
    }
}

/// Class for CreditNewProjectPopUp
class CreditNewProjectPopUp {
    
    /// Method for instatiate AddCreditToNewProjectPopUpVC and present alert
    func alert(credit: CreditRepository) -> AddCreditToNewProjectPopUpVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.simulations.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: SimulationsVC.creditNewProject.identifier) as! AddCreditToNewProjectPopUpVC
        alertVC.creditRepository = credit
        return alertVC
    }
}

/// Class for CreditExistantProjectPopUp
class CreditExistantProjectPopUp {
    
    /// Method for instatiate AddCreditToExistantProjectPopUpVC and present alert
    func alert(credit: CreditRepository) -> AddCreditToExistantProjectPopUpVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.simulations.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: SimulationsVC.creditExistantProject.identifier) as! AddCreditToExistantProjectPopUpVC
        alertVC.creditRepository = credit
        return alertVC
    }
}

/// Class for ReplaceCreditPopUp
class ReplaceCreditPopUp {
    
    /// Method for instatiate ReplaceCreditViewController and present alert
    func alert(project: Project, credit: CreditRepository) -> ReplaceCreditViewController {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.simulations.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: SimulationsVC.creditReplaceProject.identifier) as! ReplaceCreditViewController
        alertVC.creditRepository = credit
        alertVC.selectedProject = project
        return alertVC
    }
}
