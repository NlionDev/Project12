//
//  SavedSimulationTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class SavedProjectsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak private var name: UILabel!
    
    //MARK: - Methods
    func configure(projectName: String) {
        name.text = projectName
    }
}
