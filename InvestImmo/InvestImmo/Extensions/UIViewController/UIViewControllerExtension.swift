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

    func hideNavBarRightButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func hideNavBarBackItemTitle() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    // Method for add a button to navigation bar
    func setupNavBarRightButton(image: UIImage, action: Selector) {
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = button
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    
    func isMyProjectNameUnique(name: String, projects: Results<Project>) -> Bool {
        var result = true
        for project in projects {
            if name == project.name {
                result = false
            } else {
                result = true
            }
        }
        return result
    }
    
    func addKeyboardObservers(method: Selector) {
        NotificationCenter.default.addObserver(self, selector: method, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: method, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: method, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
