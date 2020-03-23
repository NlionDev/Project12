//
//  CreditViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 22/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
}

protocol UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
}

class CreditViewController: UIViewController {
    
    //MARK: - Properties
    
    var creditDuration = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    
    //MARK: - Outlets
    
    @IBOutlet weak var creditDurationPickerView: UIPickerView!
    

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCreditNavigationBarStyle()
        
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
}
