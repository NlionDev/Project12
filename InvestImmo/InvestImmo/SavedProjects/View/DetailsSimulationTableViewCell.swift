//
//  DetailsTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 19/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class DetailsSimulationTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var resultLabel: UILabel!
    
 //MARK: - Methods
    func configure(title: String, result: String) {
        titleLabel.text = title
        resultLabel.text = result
    }
    
}
