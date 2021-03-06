//
//  MenuBarCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bankIcon")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(red: 55/255.0, green: 70/255.0, blue: 128/255.0, alpha: 1.0)
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : UIColor(red: 55/255.0, green: 70/255.0, blue: 128/255.0, alpha: 1.0)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : UIColor(red: 55/255.0, green: 70/255.0, blue: 128/255.0, alpha: 1.0)
        }
    }
    

    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    //MARK: - Methods
    func configure(image: UIImage) {
        imageView.image = image
        imageView.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    private func setupView() {
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(25)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(25)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
