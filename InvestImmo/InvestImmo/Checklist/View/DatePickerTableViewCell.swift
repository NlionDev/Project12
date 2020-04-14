//
//  DatePickerTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol DatePickerData: class {
    func getDatePickerData(key: String, value: String, sectionKey: Int)
}

class DatePickerTableViewCell: UITableViewCell {
    
    
    //MARK: - Properties
    
    weak var delegate: DatePickerData?
    var key = String()
    var section = Int()
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellDatePicker: UIDatePicker!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellDatePicker.locale = .current
        cellDatePicker.setValue(UIColor(red: 91/255.0, green: 102/255.0, blue: 248/255.0, alpha: 1.0), forKeyPath: "textColor")
    }
    //MARK: - Actions
    
    
    @IBAction func didChangeDate(_ sender: Any) {
        let newValue = cellDatePicker.date.transformIntoString
        delegate?.getDatePickerData(key: key, value: newValue, sectionKey: section)
    }
    
    //MARK: - Methods
    
    func configure(title: String, sectionKey: Int) {
        key = title
        section = sectionKey
        titleLabel.text = title
    }
    
}
