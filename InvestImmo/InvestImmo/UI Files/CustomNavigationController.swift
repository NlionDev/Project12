//
//  CustomNavigationController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for CustomNavigationController
class CustomNavigationController: UINavigationController {

    //MARK: - Properties
    
    /// Property for status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }
    
    //MARK: - Methods
    
    /// Method for configure navigation bar style
    private func setupStyle() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Poetsen One", size: 30),
                          NSAttributedString.Key.foregroundColor: UIColor(ciColor: .white)]
        navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationBar.backIndicatorImage = UIImage(named: "arrow")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = false
    }

}
