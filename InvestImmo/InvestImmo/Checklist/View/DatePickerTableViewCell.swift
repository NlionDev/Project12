//
//  DatePickerTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for DatePickerTableViewCellDelegate
protocol DatePickerTableViewCellDelegate: class {
    func datePickerTableViewCell(_ datePickerTableViewCell: DatePickerTableViewCell, key: String, value: String, sectionKey: Int)
}

/// Class for DatePickerTableViewCell
class DatePickerTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    /// Property for delegate
    weak var delegate: DatePickerTableViewCellDelegate?
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for store selected section to store data in data dictionary
    private var section = Int()
    
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
    
    /// Action activated when date in pickerview was changed for retrieve selected date
    @IBAction func didChangeDate(_ sender: Any) {
        let newValue = cellDatePicker.date.transformIntoString
        delegate?.datePickerTableViewCell(self, key: key, value: newValue, sectionKey: section)
    }
    
    //MARK: - Methods
    
    /// Method for configure cell with data
    func configure(title: String, sectionKey: Int) {
        key = title
        section = sectionKey
        titleLabel.text = title
    }
    
}
