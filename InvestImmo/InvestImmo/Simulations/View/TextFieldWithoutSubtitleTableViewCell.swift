//
//  TextFieldWithoutSubtitleTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    func textFieldTableViewCell(key: String, value: String)
}

class TextFieldWithoutSubtitleTableViewCell: UITableViewCell, UITextFieldDelegate {

    //MARK: - Properties
    private var key = String()
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
    func configure(title: String, unit: String) {
        key = title
        titleLabel.text = title
        unitLabel.text = unit
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = cellTextField.text {
        delegate?.textFieldTableViewCell(key: key, value: text)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cellTextField.resignFirstResponder()
        return true
    }
}
