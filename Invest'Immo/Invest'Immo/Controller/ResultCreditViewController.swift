//
//  ResultCreditViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 22/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ResultCreditViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var creditResultStackView: UIStackView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeButtonItem(action: #selector(didTapOnHomeButton))
    }
    
    //MARK: - Actions
    
    // Method for go back to home menu when tapped in
    @objc private func didTapOnHomeButton() {
        performSegue(withIdentifier: "returnHomeFromCreditResult", sender: nil)
    }
    

 

}

