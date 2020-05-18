//
//  UI HardCoding Values.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 15/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//
import UIKit

//MARK: - Properties
let emptyString = ""
let poetsenOneFont = "Poetsen One"
let adressFontSize: CGFloat = 13
let antipastoFont = "AntipastoPro"
let sectionTitleFontSize: CGFloat = 50
let sectionHeaderHeight: CGFloat = 30

//MARK: - Enum
enum Purple {
    case red
    case green
    case blue
    case alpha
    
    var colorValue: CGFloat {
        switch self {
        case .red:
            return 91/255.0
        case .green:
            return 102/255.0
        case .blue:
            return 248/255.0
        case .alpha:
            return 1.0
        }
    }
}
