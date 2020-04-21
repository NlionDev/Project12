//
//  SavedTextViewTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class SavedTextViewTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    

    //MARK: - Methods
    
    func configure(title: String, result: String) {
        titleLabel.text = title
        resultsLabel.text = result
    }
    
}
