//
//  Simulation.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class RentabilitySimulation: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var estatePrice: String?
    @objc dynamic var worksPrice: String?
    @objc dynamic var notaryFees: String?
    @objc dynamic var monthlyRent: String?
    @objc dynamic var propertyTax: String?
    @objc dynamic var maintenanceFees: String?
    @objc dynamic var charges: String?
    @objc dynamic var managementFees: String?
    @objc dynamic var insurance: String?
    @objc dynamic var creditCost: String?
    @objc dynamic var grossYield: String?
    @objc dynamic var netYield: String?
    @objc dynamic var annualCashflow: String?
    @objc dynamic var mensualCashflow: String?
}
