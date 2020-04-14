//
//  TextFiedlEurosTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class TextFieldWithSubtitleTableViewCell: UITableViewCell, UITextFieldDelegate {

    //MARK: - Properties
    
    weak var delegate: TextFieldData?
    private var key = String()
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.delegate = self
        
    }
    
    //MARK: - Methods
    
    func configure(title: String, subtitle: String) {
        key = title
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = cellTextField.text {
        delegate?.getTextFieldData(key: key, value: text)
        }
        
        return true
    }
}
