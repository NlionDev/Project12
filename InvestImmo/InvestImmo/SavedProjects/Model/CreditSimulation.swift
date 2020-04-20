//
//  CreditSimulation.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 16/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class CreditSimulation: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var amountToFinance: String?
    @objc dynamic var duration: String?
    @objc dynamic var rate: String?
    @objc dynamic var insuranceRate: String?
    @objc dynamic var bookingFees: String?
    @objc dynamic var mensuality: String?
    @objc dynamic var interestCost: String?
    @objc dynamic var insuranceCost: String?
    @objc dynamic var totalCost: String?

}
