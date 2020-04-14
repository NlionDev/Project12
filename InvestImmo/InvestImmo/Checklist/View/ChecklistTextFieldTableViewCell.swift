//
//  ChecklistTextFieldTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 09/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol ChecklistTextFieldData: class {
    func getChecklistTextFieldData(key: String, value: String, sectionKey: Int)
}

class ChecklistTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {


    //MARK: - Properties
    
    weak var delegate: ChecklistTextFieldData?
    private var key = String()
    private var section = Int()
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.clear()
        cellTextField.delegate = self
    }
    
    //MARK: - Methods
    
    func configure(title: String, unit: String, sectionKey: Int) {
        key = title
        section = sectionKey
        titleLabel.text = title
        unitLabel.text = unit
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = cellTextField.text {
        delegate?.getChecklistTextFieldData(key: key, value: text, sectionKey: section)
        }
        return true
    }

}
