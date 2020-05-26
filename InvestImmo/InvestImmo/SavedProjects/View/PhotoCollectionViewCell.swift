//
//  PhotoCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 22/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for PhotoCollectionViewCell
class PhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
    }
    
    //MARK: - Methods
    
    /// Method for configure cell with photo
    func configure(photo: UIImage) {
        photoImageView.image = photo
    }
}
