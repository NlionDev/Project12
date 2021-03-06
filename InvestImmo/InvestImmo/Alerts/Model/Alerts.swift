//
//  Alerts.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//


import UIKit


class ErrorAlert {
    
    func alert(message: String) -> ErrorAlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "ErrorAlertVC") as! ErrorAlertViewController
        alertVC.message = message
        return alertVC
    }
}
