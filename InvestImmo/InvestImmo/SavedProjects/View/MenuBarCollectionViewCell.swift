//
//  MenuBarCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

/// Class for MenuBarCollectionViewCell
class MenuBarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    /// Property for instantiate and setup menu bar icons
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bankIcon")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = darkPurple
        return iv
    }()
    
    /// Property for set icon color when is highlighted
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : darkPurple
        }
    }
    
    /// Propertry for set icon color when is selected
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : darkPurple
        }
    }
    

    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    //MARK: - Methods
    
    /// Method for configure cell with data
    func configure(image: UIImage) {
        imageView.image = image
        imageView.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    /// Method for configure cell subviews
    private func setupView() {
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(25)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(25)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
