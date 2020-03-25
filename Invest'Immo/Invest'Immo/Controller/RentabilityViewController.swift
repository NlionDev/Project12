//
//  RentabilityViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 21/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class RentabilityViewController: UIViewController {

    //MARK: - Properties
    
    private let calculator = RentabilityCalculator()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRentabilityNavigationBarStyle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRentabilityResult" {
            guard let destination = segue.destination as? ResultRentabilityViewController else {return}
            if let estatePrice = estatePriceTextField.text,
                let worksPrice = worksPriceTextField.text,
                let notaryFees = notaryFeesTextField.text,
                let monthlyRent = monthlyRentTextField.text,
                let propertyTax = propertyTaxTextField.text,
                let maintenanceFees = maintenanceFeesTextField.text,
                let charges = chargesTextField.text,
                let managementFees = managementFeesTextField.text,
                let insurance = insuranceTextField.text,
                let creditCost = creditCostTextField.text {
                calculator.estatePrice = estatePrice
                calculator.worksPrice = worksPrice
                calculator.notaryFees = notaryFees
                calculator.monthlyRent = monthlyRent
                calculator.propertyTax = propertyTax
                calculator.maintenanceFees = maintenanceFees
                calculator.charges = charges
                calculator.managementFees = managementFees
                calculator.insurance = insurance
                calculator.creditCost = creditCost
                destination.calculator = calculator
            }
        }
    }
        
        
        //MARK: - Outlets
        
    @IBOutlet weak var estatePriceTextField: UITextField!
    @IBOutlet weak var worksPriceTextField: UITextField!
    @IBOutlet weak var notaryFeesTextField: UITextField!
    @IBOutlet weak var monthlyRentTextField: UITextField!
    @IBOutlet weak var propertyTaxTextField: UITextField!
    @IBOutlet weak var maintenanceFeesTextField: UITextField!
    @IBOutlet weak var chargesTextField: UITextField!
    @IBOutlet weak var managementFeesTextField: UITextField!
    @IBOutlet weak var insuranceTextField: UITextField!
    @IBOutlet weak var creditCostTextField: UITextField!
    
    
        
        //MARK: - Actions
        
    // Method for hide keyboard when tap on screen
    @IBAction func dismissKeyboard(_ sender: Any) {
        estatePriceTextField.resignFirstResponder()
        worksPriceTextField.resignFirstResponder()
        notaryFeesTextField.resignFirstResponder()
        monthlyRentTextField.resignFirstResponder()
        propertyTaxTextField.resignFirstResponder()
        maintenanceFeesTextField.resignFirstResponder()
        chargesTextField.resignFirstResponder()
        managementFeesTextField.resignFirstResponder()
        insuranceTextField.resignFirstResponder()
        creditCostTextField.resignFirstResponder()
    }
    
        



    }

    //MARK: - Extensions

    extension RentabilityViewController: UITextFieldDelegate {
        
        // Method for hide Keyboard when tap on return key
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
