//
//  CreditViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 22/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController {
    
    //MARK: - Properties
    
    private let creditDuration = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    private let calculator = CreditCalculator()
    private let customPickerView = CustomPickerView()
    var selectedCreditDuration: Int?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var creditDurationPickerView: UIPickerView!
    @IBOutlet weak var amountToFinanceTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var insuranceRateTextField: UITextField!
    @IBOutlet weak var bookingFeesTextField: UITextField!
    

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCreditNavigationBarStyle()
        customPickerView.setupDurationPickerView(picker: creditDurationPickerView, array: creditDuration)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCreditResult" {
            
            guard let destination = segue.destination as? ResultCreditViewController else {return}
            let creditDurationIndex = creditDurationPickerView.selectedRow(inComponent: 0)
            selectedCreditDuration = creditDuration[creditDurationIndex]
            if let amountToFinance = amountToFinanceTextField.text,
                let creditDuration = selectedCreditDuration,
                let rate = rateTextField.text,
                let insuranceRate = insuranceRateTextField.text,
                let bookingFees = bookingFeesTextField.text {
                calculator.amountToFinance = amountToFinance
                calculator.creditDuration = String(creditDuration)
                calculator.rate = rate
                calculator.insuranceRate = insuranceRate
                calculator.bookingFees = bookingFees
                destination.calculator = calculator
                
            }
        }
    }
    
    //MARK: - Actions

    @IBAction func dismissKeyboard(_ sender: Any) {
        amountToFinanceTextField.resignFirstResponder()
        rateTextField.resignFirstResponder()
        insuranceRateTextField.resignFirstResponder()
        bookingFeesTextField.resignFirstResponder()
    }
    @IBAction func didTapOnRatePlusButton(_ sender: Any) {
        if let rate = Double(calculator.rate) {
            let newRate = rate + 0.01
            let stringNewRate = String(newRate)
            calculator.rate = stringNewRate
            
            
        }
    }
    
    @IBAction func didTapOnRateMinusButton(_ sender: Any) {
    }
    
    //MARK: - Methods
    


}

//MARK: - Extension

extension CreditViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return creditDuration.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(creditDuration[row])
    }
}
