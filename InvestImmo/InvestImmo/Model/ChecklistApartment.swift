//
//  ChecklistApartment.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class ChecklistApartment: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var dpe: String?
    @objc dynamic var light: String?
    @objc dynamic var dualAspect: String?
    @objc dynamic var vmc: String?
    @objc dynamic var humidity: String?
    @objc dynamic var heightUnderCeiling: String?
    @objc dynamic var planeness: String?
    @objc dynamic var insulation: String?
    @objc dynamic var soundInsulation: String?
    @objc dynamic var direction: String?
    @objc dynamic var bedroom: String?
    @objc dynamic var liferoom: String?
    @objc dynamic var heatingSystem: String?
    @objc dynamic var heatingType: String?
    @objc dynamic var electricity: String?
    @objc dynamic var electricityMeters: String?
    @objc dynamic var toilet: String?
    @objc dynamic var bathroom: String?
    @objc dynamic var plumbingQuality: String?
    @objc dynamic var groundQuality: String?
    @objc dynamic var wallQuality: String?
    @objc dynamic var shutters: String?
    @objc dynamic var doubleGlazing: String?
    @objc dynamic var reconfiguration: String?
    @objc dynamic var cave: String?
    @objc dynamic var caveSurface: String?
    @objc dynamic var parking: String?
    @objc dynamic var distinguishElements: String?
}
