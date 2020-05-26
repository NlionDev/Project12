//
//  ResultTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for Result table view cell
class ResultTableViewCell: UITableViewCell {


    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var resultLabel: UILabel!
    
    //MARK: - Methods
    
    /// Method for configure cell with rentability data
    func configureForRenta(title: String, result: String, isPositive: Bool) {
        titleLabel.text = title
        resultLabel.text = result
        if isPositive {
            resultLabel.textColor = green
        } else {
            resultLabel.textColor = red
        }
    }
    
    /// Method for configure cell with credit data
    func configureForCredit(title: String, result: String) {
        titleLabel.text = title
        resultLabel.text = result
    }
    
}
