//
//  NoDataCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 19/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class NoDataCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    //MARK: - Methods
    
    func configure(message: String) {
        messageLabel.text = message
    }
}
