//
//  SavedTextViewTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for SavedTextViewTableViewCell
class SavedTextViewTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var resultsLabel: UILabel!
    
    //MARK: - Methods
    
    /// Method for configure cell with data
    func configure(title: String, result: String) {
        titleLabel.text = title
        resultsLabel.text = result
    }
    
}
