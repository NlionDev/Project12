//
//  ResultView.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 22/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class ResultView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    
    }
    
    private func configureView() {
        self.layer.cornerRadius = 20
    }
}
