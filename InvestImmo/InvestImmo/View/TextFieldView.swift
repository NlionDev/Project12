//
//  TextFieldView.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 21/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class TextFieldView: UITextField {
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextFieldStyle()
    }
    
    //MARK: - Methods
    
    // Method to configure TextFieldStyle
    private func configureTextFieldStyle() {
        self.layer.cornerRadius = 10
    }
}
