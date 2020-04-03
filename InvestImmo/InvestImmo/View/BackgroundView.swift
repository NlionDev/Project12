//
//  BackgroundView.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class BackgroundView: UIView {
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBackgroundView()
    }
    
    //MARK: - Methods
    
    private func setupBackgroundView() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "building")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFit
        backgroundImage.alpha = 0.2
        self.insertSubview(backgroundImage, at: 0)
    }
}
