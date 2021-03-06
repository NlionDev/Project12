//
//  NewProjectPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class EmptyNewProjectPopUp {
    
    func alert() -> CreateNewProjectViewController {
        let storyboard = UIStoryboard(name: "NewProjectStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "EmptyNewProjectAlertVC") as! CreateNewProjectViewController
        return alertVC
    }
}
