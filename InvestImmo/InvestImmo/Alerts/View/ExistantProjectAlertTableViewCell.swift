//
//  ChecklistAlertTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 04/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

/// Class for ExistantProjectAlertTableViewCell
class ExistantProjectAlertTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak private var nameLabel: UILabel!
        
    //MARK: - Methods
    
    /// Method for configure cell with name
    func configure(projectName: String) {
        nameLabel.text = projectName
    }
}
