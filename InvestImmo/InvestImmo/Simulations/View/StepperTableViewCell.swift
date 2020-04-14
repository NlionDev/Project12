//
//  StepperTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class StepperTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    //MARK: - Properties
    
    var key = String()
    weak var delegate: TextFieldData?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnPlusButton(_ sender: Any) {
        if let rate = cellTextField.text?.transformInDouble {
            let newRate = rate + 0.01
            let stringNewRate = newRate.formatIntoStringWithTwoNumbersAfterPoint
            cellTextField.text = stringNewRate
        }
    }
    
    @IBAction func didTapOnMinusButton(_ sender: Any) {
        if let rate = cellTextField.text?.transformInDouble {
            let newRate = rate - 0.01
            if newRate <= 0 {
                let stringZero = String(0)
                cellTextField.text = stringZero
            } else {
                let stringNewRate = newRate.formatIntoStringWithTwoNumbersAfterPoint
                cellTextField.text = stringNewRate
            }
        }
    }
    
    
    //MARK: - Methods
    
    func configure(title: String) {
        key = title
        titleLabel.text = title
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = cellTextField.text {
            delegate?.getTextFieldData(key: key, value: text)
        }
        return true
    }
    
}
