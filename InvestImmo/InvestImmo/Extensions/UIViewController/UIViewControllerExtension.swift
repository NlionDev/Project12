//
//  UIViewControllerExtension.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 29/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift
import UIKit

extension UIViewController {
    
    // MARK: - Methods for configure Views

    /// Method for hide navigation bar right button
    func hideNavBarRightButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    /// Method for hide navigation bar back item title
    func hideNavBarBackItemTitle() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    /// Method for add a button to navigation bar
    func setupNavBarRightButton(image: UIImage, action: Selector) {
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = button
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    /// Method for add observers to a view controller
    func addKeyboardObservers(method: Selector) {
        NotificationCenter.default.addObserver(self, selector: method, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: method, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: method, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Method for remove observers to a view controller
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
