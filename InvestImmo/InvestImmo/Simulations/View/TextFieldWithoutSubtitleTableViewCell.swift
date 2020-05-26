//
//  TextFieldWithoutSubtitleTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for TextFieldTableViewCellDelegate
protocol TextFieldTableViewCellDelegate: class {
    func textFieldTableViewCell(key: String, value: String)
}

/// Class for TextField without subtitle cell
class TextFieldWithoutSubtitleTableViewCell: UITableViewCell, UITextFieldDelegate {

    //MARK: - Properties
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for delegate
    weak var delegate: TextFieldTableViewCellDelegate?

    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var unitLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.delegate = self
    }
    
    //MARK: - Methods
    
    /// Method for configure the cell with data
    func configure(title: String, unit: String) {
        key = title
        titleLabel.text = title
        unitLabel.text = unit
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
