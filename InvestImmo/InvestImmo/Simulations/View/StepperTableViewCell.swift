//
//  StepperTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for stepper Table View Cell
class StepperTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - Properties
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for delegate
    weak var delegate: TextFieldTableViewCellDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.delegate = self
    }
    
    //MARK: - Actions
    
    /// Action activated when tap on plus button for add 0.01 to current value
    @IBAction private func didTapOnPlusButton(_ sender: Any) {
        if let rate = cellTextField.text?.transformInDouble {
            let newRate = rate + 0.01
            let stringNewRate = newRate.formatIntoStringWithTwoNumbersAfterPoint
            cellTextField.text = stringNewRate
        }
    }
    
    /// Action activated when tap on minus button for substract 0.01 to current value
    @IBAction private func didTapOnMinusButton(_ sender: Any) {
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
    
    /// Method for configure cell with data
    func configure(title: String) {
        key = title
        titleLabel.text = title
    }
    
    /// Method call when textfield should end editing
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = cellTextField.text {
            delegate?.textFieldTableViewCell(key: key, value: text)
        }
        return true
    }
    
    /// Method call when user tap on keyboard return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cellTextField.resignFirstResponder()
        return true
    }
    
}
