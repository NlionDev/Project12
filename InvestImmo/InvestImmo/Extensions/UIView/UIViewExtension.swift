//
//  UIViewExtension.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 29/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

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
