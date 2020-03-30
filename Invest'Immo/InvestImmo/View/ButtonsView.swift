//
//  ButtonsView.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 21/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class ButtonsView: UIButton {
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButtonStyle()
        
    }
    
    //MARK: - Methods
    
    // Method to configure button style
    private func configureButtonStyle() {
        self.layer.cornerRadius = 30
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderWidth = 2
    }
}
