//
//  Extensions.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 22/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

//MARK: - ViewController Extension

extension UIViewController {
    
    // Method for customize navigation bar on rentability display
    func setRentabilityNavigationBarStyle() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 91/255.0, green: 102/255.0, blue: 248/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poetsen One", size: 30)!]
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    // Method for customize navigation bar on credit display
    func setCreditNavigationBarStyle() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 100/255.0, green: 172/255.0, blue: 217/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poetsen One", size: 30)!]
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    // Method for customize navigation bar on home menu display
    func setHomeNavigationBarStyle() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Method for add a home button to navigation bar
    func setupHomeButtonItem(action: Selector) {
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeButton"), style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    // Method for go back to home menu when tapped in
    @objc func didTapOnHomeButton() {
        performSegue(withIdentifier: "returnHome", sender: nil)
    }
}

//MARK: - Double Extension

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
