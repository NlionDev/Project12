//
//  ResultTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {


    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var resultLabel: UILabel!
    
    //MARK: - Methods
    func configureForRenta(title: String, result: String, isPositive: Bool) {
        titleLabel.text = title
        resultLabel.text = result
        if isPositive {
            resultLabel.textColor = UIColor(red: 33/255.0, green: 227/255.0, blue: 40/255.0, alpha: 1.0)
        } else {
            resultLabel.textColor = UIColor(red: 227/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
        }
    }
    
    func configureForCredit(title: String, result: String) {
        titleLabel.text = title
        resultLabel.text = result
    }
    
}
