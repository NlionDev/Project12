//
//  PickerViewTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for PickerViewTableViewCellDelegate
protocol PickerViewTableViewCellDelegate: class {
    func pickerViewTableViewCell(_ pickerViewTableViewCell: PickerViewTableViewCell, key: String, value: Int)
}

/// Class for PickerView cell
class PickerViewTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    /// Instance of CreditRepository
    private let creditRepo = CreditRepository()
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for stock selected index for pickerview
    var selectedPickerData = Int()
    
    /// Property for delegate
    weak var delegate: PickerViewTableViewCellDelegate?
 
    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var durationPicker: UIPickerView!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        durationPicker.delegate = self
        durationPicker.dataSource = self
        setupDurationPickerView()
    }
    
    //MARK: - Methods
    
    /// Method for configure the PickerView
    private func setupDurationPickerView() {
        durationPicker.setValue(purple, forKeyPath: textColorKeyPath)
        let middleOfPicker = creditRepo.creditDuration.count/2
        durationPicker.selectRow(middleOfPicker, inComponent: 0, animated: true)
        selectedPickerData = middleOfPicker
    }
    
    /// Method for configure the cell with data
    func configure(title: String, subtitle: String) {
        key = title
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
}

//MARK: - Extension

/// Extension of PickerViewTableViewCell for PickerView Delegate and DataSource
extension PickerViewTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return creditRepo.creditDuration.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(creditRepo.creditDuration[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerData = creditRepo.creditDuration[durationPicker.selectedRow(inComponent: component)]
        delegate?.pickerViewTableViewCell(self, key: key,value: selectedPickerData)
    }
    
}
