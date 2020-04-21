//
//  MenuBarSimulationCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class MenuBarSimulationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Antipasto Pro", size: 20)
        title.textColor = UIColor(red: 55/255.0, green: 70/255.0, blue: 128/255.0, alpha: 1.0)
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
        
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : UIColor(red: 55/255.0, green: 70/255.0, blue: 128/255.0, alpha: 1.0)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : UIColor(red: 55/255.0, green: 70/255.0, blue: 128/255.0, alpha: 1.0)
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    //MARK: - Methods
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:[v0(150)]", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: titleLabel)
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
