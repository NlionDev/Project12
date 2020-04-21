//
//  Extensions.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 22/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

//MARK: - ViewController Extension

extension UIViewController {
    
    // MARK: - Methods for configure Views

    // Method for add a home button to navigation bar
    func setupSaveButtonItem(action: Selector) {
        let saveButton = UIBarButtonItem(image: #imageLiteral(resourceName: "saveIcon"), style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func setupNewProjectButton(action: Selector) {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "addIcon"), style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = button
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func configureBackgroundImageForTableView(tableView: UITableView) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "building")
        backgroundImage.contentMode =  UIView.ContentMode.redraw
        backgroundImage.alpha = 0.2
        tableView.insertSubview(backgroundImage, at: 0)
    }
    
    //MARK: - Methods for display alert
    
    func displayAlertForDuplicateProjectName() {
        let alert = UIAlertController(title: "Enregistrement Impossible", message: "Un projet existant porte déjà ce nom.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retour", style: .cancel, handler: { (UIAlertAction) in }))
        present(alert, animated: true)
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
    
    func isMySavedProjectsNil(projects: Results<Project>) -> Bool {
        if projects.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func isMyRentabilityDataNil(numberToTest: Int) -> Bool {
        if numberToTest == 0 {
            return true
        } else {
            return false
        }
    }
    
    
}

//MARK: - Double Extension

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    
    var formatIntoStringWithTwoNumbersAfterPoint: String {
        return String(format: "%.02f", self)
        
    }
}

//MARK: - Formatter Extension

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

//MARK: - String Extension

extension String {
    var transformInDouble: Double {
        var number = 0.00
       let newString = self.replacingOccurrences(of: ",", with: ".")
        if let doubleString = Double(newString) {
            number = doubleString
        }
        return number
    }
}

//MARK: - Date Extension

extension Date {
    var transformIntoString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .medium
        let myString = formatter.string(from: self)
        return myString
    }
}

//MARK: - TextField Extension
extension UITextField {
    func clear() {
        self.text = ""
    }
}

//MARK: - TextView Extension
extension UITextView {
    func clear() {
        self.text = ""
    }
}

//MARK: - Realm Extension

extension Realm {
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        }
        catch {
            // LOG ERROR
        }
        return nil
    }

    func safeWrite(_ block: () -> ()) {
        do {
            // Async safety, to prevent "Realm already in a write transaction" Exceptions
            if !isInWriteTransaction {
                try write(block)
            }
        } catch {
            // LOG ERROR
        }
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict))
    }
}
