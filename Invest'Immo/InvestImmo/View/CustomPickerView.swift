//
//  PickerView.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 27/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Class CustomePickerView

class CustomPickerView: UIPickerView {
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "textColor")
    }
    
    //MARK: - Methods
    
    func setupStringPickerView(picker: UIPickerView, array: [String]) {
        let middleOfPicker = array.count/2
        picker.selectRow(middleOfPicker, inComponent: 0, animated: true)
    }
    
    func setupDurationPickerView(picker: UIPickerView, array: [Int]) {
        let middleOfPicker = array.count/2
        picker.selectRow(middleOfPicker, inComponent: 0, animated: true)
    }
}

//MARK: - Class CustomDatePicker

class CustomDatePicker: UIDatePicker {
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "textColor")
    }
}
