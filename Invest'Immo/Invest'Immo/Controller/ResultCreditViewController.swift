//
//  ResultCreditViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 22/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ResultCreditViewController: UIViewController {

    //MARK: - Properties
    
    var calculator: CreditCalculator?
    
    //MARK: - Outlets

    @IBOutlet weak var mensualityAmountLabel: UILabel!
    @IBOutlet weak var interestCostLabel: UILabel!
    @IBOutlet weak var insuranceCostLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeButtonItem(action: #selector(didTapOnHomeButton))
        displayResult()
    }
    
    //MARK: - Methods
    
    private func displayResult() {
        if let calculator = calculator {
            mensualityAmountLabel.text = calculator.getStringMensuality() + " €"
            interestCostLabel.text = calculator.getStringInterestCost() + " €"
            insuranceCostLabel.text = calculator.getStringInsuranceCost() + " €"
            totalCostLabel.text = calculator.getTotalCost() + " €"
        }
    }
    

   
    

 

}

