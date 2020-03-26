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
    var selectedCreditDuration: Int?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var creditDurationPickerView: UIPickerView!
    

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCreditNavigationBarStyle()
        setupPickerView()
    }
    
    private func setupPickerView() {
        let middleOfPicker = creditDuration.count/2
        creditDurationPickerView.selectRow(middleOfPicker, inComponent: 0, animated: true)
        creditDurationPickerView.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "textColor")
    }

}

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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCreditDuration = creditDuration[row]
    }
    
}
