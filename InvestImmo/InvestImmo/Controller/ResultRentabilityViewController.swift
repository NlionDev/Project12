//
//  ResultRentabilityViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 21/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class ResultRentabilityViewController: UIViewController {
    
    //MARK: - Properties
    
    var calculator: RentabilityCalculator?
    let realm = try! Realm()
    
    //MARK: - Outlets
    
    @IBOutlet weak private var grossYieldLabel: UILabel!
    @IBOutlet weak private var netYieldLabel: UILabel!
    @IBOutlet weak private var annualCashflowLabel: UILabel!
    @IBOutlet weak private var mensualCashflowLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButtonItem(action: #selector(didTapOnSaveButton))
        displayResult()
        setupLabelTextColor()
    }
    
    //MARK: - Actions
    
    @objc func didTapOnSaveButton() {
        
    }
    
    //MARK: - Methods
    
    private func displayResult() {
        if let calculator = calculator {
            grossYieldLabel.text = calculator.getGrossYield() + " %"
            netYieldLabel.text = calculator.getNetYield() + " %"
            annualCashflowLabel.text = calculator.getAnnualCashflow() + " €"
            mensualCashflowLabel.text = calculator.getMensualCashflow() + " €"
        }
    }
    
    private func adjustTextColor(result: String, label: UILabel) {
        var boolResult = true
        if let calculator = calculator {
            boolResult = calculator.isResultPositive(result: result)
        }
        if boolResult == true {
            label.textColor = UIColor(red: 33/255.0, green: 227/255.0, blue: 40/255.0, alpha: 1.0)
        } else {
            label.textColor = UIColor(red: 227/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
        }
    }
    
    private func setupLabelTextColor() {
        if let calculator = calculator {
            adjustTextColor(result: calculator.getGrossYield(), label: grossYieldLabel)
            adjustTextColor(result: calculator.getNetYield(), label: netYieldLabel)
            adjustTextColor(result: calculator.getAnnualCashflow(), label: annualCashflowLabel)
            adjustTextColor(result: calculator.getMensualCashflow(), label: mensualCashflowLabel)
        }
    }
    
    
}

