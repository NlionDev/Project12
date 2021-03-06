//
//  PhotoCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 22/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak private var photoImageView: UIImageView!
    
    //MARK: - Methods
    func configure(photo: UIImageView) {
        photoImageView = photo
    }
}
