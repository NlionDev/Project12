//
//  SavedSimulationTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class SavedSimulationTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    //MARK: - Methods
    
    func configure(projectName: String, projectPrice: String) {
        name.text = projectName
        price.text = projectPrice
    }
}
