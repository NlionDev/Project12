//
//  ErrorAlertViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ErrorAlertViewController: UIViewController {
    
    //MARK: - Properties
    var message: String?
    
    //MARK: - Outlets
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let message = message {
            alertMessageLabel.text = message
        }
    }

    //MARK: - Actions
    @IBAction func didTapOnOKButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
