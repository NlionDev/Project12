//
//  ChecklistTextFieldTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 09/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for ChecklistTextFieldTableViewCellDelegate
protocol ChecklistTextFieldTableViewCellDelegate: class {
    func checklistTextFieldTableViewCell(_ checklistTextFieldTableViewCell: ChecklistTextFieldTableViewCell, key: String, value: String, sectionKey: Int)
}

/// Class for ChecklistTextFieldTableViewCell
class ChecklistTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {


    //MARK: - Properties
    
    /// Property for delegate
    weak var delegate: ChecklistTextFieldTableViewCellDelegate?
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for store selected section to store data in data dictionary
    private var section = Int()
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.delegate = self
    }
    
    //MARK: - Methods
    
    /// Method for configure cell with data
    func configure(title: String, unit: String, sectionKey: Int) {
        key = title
        section = sectionKey
        titleLabel.text = title
        unitLabel.text = unit
    }
    
    /// Method called when textfield should end editing and retrieve textfield data
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = cellTextField.text {
        delegate?.checklistTextFieldTableViewCell(self, key: key, value: text, sectionKey: section)
        }
        return true
    }
    
    /// Method called when user tap on keyboard return button and textfield resign first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cellTextField.resignFirstResponder()
        return true
    }

}
