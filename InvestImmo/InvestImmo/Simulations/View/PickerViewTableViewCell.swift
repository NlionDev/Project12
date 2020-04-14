//
//  PickerViewTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol PickerData: class {
    func getPickerData(key: String, value: Int)
}

class PickerViewTableViewCell: UITableViewCell {

    
    //MARK: - Properties
  
    let creditRepo = CreditRepository()
    var selectedPickerData = Int()
    var key = String()
    weak var delegate: PickerData?
 
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var durationPicker: UIPickerView!
    
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
        delegate?.getPickerData(key: key,value: selectedPickerData)
    }
    
}
