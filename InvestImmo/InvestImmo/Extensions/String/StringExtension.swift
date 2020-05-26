//
//  StringExtension.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 29/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//


extension String {
    
    /// Property for transform String into Double
    var transformInDouble: Double {
        var number = 0.00
       let newString = self.replacingOccurrences(of: ",", with: ".")
        if let doubleString = Double(newString) {
            number = doubleString
        }
        return number
    }
}
