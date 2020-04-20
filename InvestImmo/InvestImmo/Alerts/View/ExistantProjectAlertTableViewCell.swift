//
//  ChecklistAlertTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class ExistantProjectAlertTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
        
    
    //MARK: - Methods
    
    func configure(projectName: String) {
        nameLabel.text = projectName
    }
}
