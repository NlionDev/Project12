//
//  CustomNavigationController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }
    
    //MARK: - Methods
    private func setupStyle() {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poetsen One", size: 30)!]
        navigationBar.backIndicatorImage = UIImage(named: "arrow")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        navigationBar.backItem?.backBarButtonItem?.title = ""
        navigationBar.backItem?.backBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = false
    }

}
