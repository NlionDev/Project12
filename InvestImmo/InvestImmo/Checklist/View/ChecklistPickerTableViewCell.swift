//
//  ChecklistPickerTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for ChecklistPickerTableViewCellDelegate
protocol ChecklistPickerTableViewCellDelegate: class {
    func checklistPickerTableViewCell(_ checklistPickerTableViewCell: ChecklistPickerTableViewCell, key: String, value: String, sectionKey: Int)
}

/// Class for ChecklistPickerTableViewCell
class ChecklistPickerTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    /// Instance of ChecklistRepository
    private let checklistRepo = ChecklistRepository()
    
    /// Property for delegate
    weak var delegate: ChecklistPickerTableViewCellDelegate?
    
    /// Property to store selected value in pickerview
    private var selectedPickerData = String()
    
    /// Property to store an array to present in pickerview
    var pickerData = [String]()
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for store selected section to store data in data dictionary
    private var section = Int()
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellPicker: UIPickerView!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellPicker.delegate = self
        cellPicker.dataSource = self
        setupPickerView()
    }
    
    //MARK: - Methods
    
    /// Method for select correct array to present in pickerview
    private func getCorrectPickerData(key: String) -> [String] {
        var data = [String]()
        if key == "Type de bien" {
            data = checklistRepo.estateTypeForPicker
        } else if key == "Diagnostic de performances énergétiques" {
            data = checklistRepo.dpeForPicker
        } else if key == "Vue de la chambre" || key == "Vue de la pièce de vie" {
            data = checklistRepo.roomViewForPicker
        } else if key == "Energie du chauffage" {
            data = checklistRepo.heatingSystemForPicker
        } else if key == "Orientation" {
            data = checklistRepo.directionForPicker
        } else {
            data = checklistRepo.qualityForPicker
        }
        return data
    }
    
    /// Method for configure pickerview
    private func setupPickerView() {
        cellPicker.setValue(purple, forKeyPath: textColorKeyPath)
        let middleOfPicker = pickerData.count/2
        cellPicker.selectRow(middleOfPicker, inComponent: 0, animated: true)
    }
    
    /// Method for configure cell with data
    func configure(title: String, sectionKey: Int) {
        section = sectionKey
        key = title
        titleLabel.text = title
        pickerData = getCorrectPickerData(key: title)
        cellPicker.reloadAllComponents()
    }
    
    
}

//MARK: - Extension

/// Extension of ChecklistPickerTableViewCell for PickerView delegate and datasource
extension ChecklistPickerTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerData = pickerData[cellPicker.selectedRow(inComponent: component)]
        delegate?.checklistPickerTableViewCell(self, key: key, value: selectedPickerData, sectionKey: section)
    }
}
