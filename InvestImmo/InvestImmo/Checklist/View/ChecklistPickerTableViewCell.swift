//
//  ChecklistPickerTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol ChecklistPickerTableViewCellDelegate: class {
    func checklistPickerTableViewCell(_ checklistPickerTableViewCell: ChecklistPickerTableViewCell, key: String, value: String, sectionKey: Int)
}

class ChecklistPickerTableViewCell: UITableViewCell {


    //MARK: - Properties
    
    private let checklistRepo = ChecklistRepository()
    weak var delegate: ChecklistPickerTableViewCellDelegate?
    private var selectedPickerData = String()
    var pickerData = [String]()
    private var key = String()
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
    
    private func setupPickerView() {
        cellPicker.setValue(UIColor(red: 91/255.0, green: 102/255.0, blue: 248/255.0, alpha: 1.0), forKeyPath: "textColor")
        let middleOfPicker = pickerData.count/2
        cellPicker.selectRow(middleOfPicker, inComponent: 0, animated: true)
    }
    
    func configure(title: String, sectionKey: Int) {
        section = sectionKey
        key = title
        titleLabel.text = title
        pickerData = getCorrectPickerData(key: title)
        cellPicker.reloadAllComponents()
    }
    
    
}

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
