//
//  MenuBarSimulationCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

/// Class for Menubar collection view
class MenuBarSimulationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    /// Property for instantiate and setup title
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: antipastoFont, size: menuBarFontSize)
        title.textColor = darkPurple
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
        
    }()
    
    /// Property for set title color when is highlighted
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : darkPurple
        }
    }
    
    /// Propertry for set title color when is selected
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : darkPurple
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    //MARK: - Methods
    
    /// Method for configure cell with title
    func configure(title: String) {
        titleLabel.text = title
    }
    
    /// Method for configure cell subviews
    private func setupView() {
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:[v0(150)]", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: titleLabel)
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
