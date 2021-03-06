//
//  PickerViewTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol PickerViewTableViewCellDelegate: class {
    func pickerViewTableViewCell(_ pickerViewTableViewCell: PickerViewTableViewCell, key: String, value: Int)
}

class PickerViewTableViewCell: UITableViewCell {

    //MARK: - Properties
    private let creditRepo = CreditRepository()
    private var key = String()
    var selectedPickerData = Int()
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
    private func setupDurationPickerView() {
        durationPicker.setValue(UIColor(red: 91/255.0, green: 102/255.0, blue: 248/255.0, alpha: 1.0), forKeyPath: "textColor")
        let middleOfPicker = creditRepo.creditDuration.count/2
        durationPicker.selectRow(middleOfPicker, inComponent: 0, animated: true)
        selectedPickerData = middleOfPicker
    }
    
    func configure(title: String, subtitle: String) {
        key = title
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
}

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
