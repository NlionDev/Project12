//
//  DoubleExtension.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 29/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation

extension Double {
    
    /// Property for truncate number after comma if the number after comma is zero
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    /// Property for truncate number with two numbers after comma
    var formatIntoStringWithTwoNumbersAfterPoint: String {
        return String(format: "%.02f", self)
        
    }
}
