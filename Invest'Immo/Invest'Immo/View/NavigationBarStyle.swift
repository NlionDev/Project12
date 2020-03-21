//
//  NavigationBarStyle.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 21/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class NavigationBarStyle: UINavigationBar {
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureNavigationBarstyle()
    }
    
    //MARK: - Methods
    
    private func configureNavigationBarstyle() {
        
        self.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poetsen One", size: 30)!]
        self.backIndicatorImage = UIImage(named: "arrow")
        self.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        self.backItem?.title = ""
    }
}
