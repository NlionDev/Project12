//
//  DetailsTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 19/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class DetailsSimulationTableViewCell: UITableViewCell {
    
    //MARK: - Properties

    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

 //MARK: - Methods
    
    func configure(title: String, result: String) {
        titleLabel.text = title
        resultLabel.text = result
    }
    
}
